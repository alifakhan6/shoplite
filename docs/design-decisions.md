# ShopLite design decisions

## Why PostgreSQL, MongoDB, and Redis?

Users and orders have stable fields and benefit from relational constraints, so
PostgreSQL is a straightforward choice. Product attributes can vary by product
type, which makes MongoDB's document model convenient for this exercise. The
notifications are short-lived records accessed by user ID, so Redis lists with
an expiry provide a deliberately simple implementation.

## Why RabbitMQ instead of Kafka?

ShopLite needs one small work queue, not a large event-streaming platform.
RabbitMQ is quick to run locally, supports durable queues and acknowledgements,
and clearly demonstrates asynchronous delivery. Kafka would become reasonable
if the organization needed retained event history, replay by several consumer
groups, or much higher event throughput.

## Why are user and catalog checks synchronous?

An order should not be accepted for a missing user or product, and the product
price is needed to calculate the order total. `order-service` therefore waits
for those two REST responses, with a three-second timeout. A notification is
not required to complete the customer's order, so it is sent asynchronously.

## Why does every service own its database?

Database ownership prevents one service from depending on another service's
tables and allows each service to evolve independently. The cost is additional
operational work: more database instances, credentials, backups, migrations,
monitoring, and cross-service consistency problems.

## What would change in production?

First, databases would use managed services or properly configured StatefulSets
instead of simple Deployments. Second, credentials would come from a secret
manager rather than a repository-managed Kubernetes Secret. Third, the system
would add authentication, authorization, schema migrations, structured
observability, dead-letter handling, idempotent message processing, and a
transactional outbox so an order and its event cannot become inconsistent.


## Kubernetes-specific decisions

### Why is `01-secret.yaml` committed in plain text?
For this learning assignment, the Secret uses the same throwaway development
credentials already committed in `.env.example`. In a real deployment this
would be wrong — secrets belong in a manager like AWS Secrets Manager, Vault,
or Sealed Secrets, injected at deploy time, never in git history. Kept as-is
here for simplicity and transparency about the trade-off, rather than hiding
it behind a `.gitignore` entry that would make the manifests incomplete on
their own.

### Why two Ingress resources instead of one?
`shoplite-ingress` (API) needs `nginx.ingress.kubernetes.io/rewrite-target`
with regex capture groups to strip the `/api` prefix before forwarding to each
service. The frontend's routes (`/` and `/static`) need no rewriting at all —
mixing the two in one Ingress object would apply the same rewrite annotation
to every path, breaking the frontend routes. Splitting them keeps each
Ingress's behavior simple and correct rather than fighting one annotation set
against two different needs.

### Why `strategy: Recreate` on `catalog-db` but not the other databases?
During initial deployment, a rolling update briefly ran two MongoDB pods
against the same PersistentVolumeClaim, and the second `mongod` process
refused to start because the data directory's lock file was already held by
the first. `Recreate` forces the old pod to fully terminate before a
replacement starts, which is the correct behavior for any single-replica
workload backed by a ReadWriteOnce volume. The other databases hit the same
class of risk in theory; `catalog-db` is where it actually surfaced during
testing.

### Why liveness on `/healthz` but readiness on `/readyz`?
Liveness answers "is the process alive at all" and intentionally avoids
checking the database — if it did, a slow database would cause Kubernetes to
kill and restart an otherwise-healthy application pod, making a database
problem worse instead of better. Readiness checks the database connection,
since a pod that can't reach its database shouldn't receive traffic, but
should stay running rather than restart.
