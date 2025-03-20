# Guidelines for writing Neo4j Database queries

- Always use parameterized queries to prevent Cypher injection vulnerabilities and improve query performance. Never embed user input directly into Cypher strings.

***Good Example**

```python

query = """

CREATE (n:Item {name: $name, description: $description})

RETURN n { .id, .name, .description } AS item

"""

result = session.run(query, name=item.name, description=item.description).single()

if result:

return Item(**result['item'])

return None

```

***Bad Example**

```python

# AVOID THIS - VULNERABLE!

query = f"""

CREATE (n:Item {{name: '{item.name}', description: '{item.description}'}})

RETURN n

"""

session.run(query)

```

- Always use parameterized Cypher queries to prevent Cypher injection vulnerabilities and improve query performance. Never embed user input directly into Cypher strings.

***Good Example**

```python

query = """

CREATE (n:Item {name: $name, description: $description})

RETURN n { .id, .name, .description } AS item

"""

result = session.run(query, name=item.name, description=item.description).single()

if result:

return Item(**result['item'])

return None

```

***Bad Example**

```python

query = f"""

CREATE (n:Item {{name: '{item.name}', description: '{item.description}'}})

RETURN n

"""

session.run(query)

```

- Use Neo4j transactions to ensure atomicity and consistency for operations that involve multiple database modifications. Wrap related Cypher operations within a transaction block to maintain data integrity, especially in complex CRUD operations.

***Example: Using transactions:**

```python

from neo4j import Transaction

def create_item_in_db(tx: Transaction, item: ItemCreate): # Transaction as parameter

query = """

CREATE (n:Item {name: $name, description: $description})

RETURN n { .id, .name, .description } AS item

"""

result = tx.run(query, name=item.name, description=item.description).single()

if result:

return Item(**result['item'])

return None

@router.post("/items/", response_model=Item)

async def create_item(item: ItemCreate, driver: GraphDatabase.driver = Neo4jDriverDependency):

with driver.session() as session:

created_item = session.execute_write(create_item_in_db, item) # Execute within transaction

return created_item

```
