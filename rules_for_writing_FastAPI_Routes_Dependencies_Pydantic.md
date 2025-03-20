# FastAPI Routes, Dependencies and Pydantic guidelines

## General

- Always follow guidelines in @rules.md

- Don't use or add any tools that isnt in @tools.md

- Refer to @project_structure.md to know the current project structure and update the files according to your modifications

## FastAPI

- Use standard Python type hints to define the inputs and outputs of your functions and endpoints.

**Good Example:**

```python

def add(x: int, y: int) -> int:

return x + y

```

***Bad Example:**

```python

def add(x, y):

return x + y

```

- Use dependency injection to manage the dependencies of your functions and endpoints.

- Dependencies can use other dependencies and avoid code repetition for the similar logic.

**Good Example:**

```python

from fastapi import FastAPI, Depends

from pydantic import BaseModel

app = FastAPI()

class User(BaseModel):

username: str

password: str

def get_current_user(user: User = Depends()):

return user

@app.get("/users/me")

def read_current_user(current_user: User = Depends(get_current_user)):

return current_user

```

**Bad Example:**

```python

from fastapi import FastAPI, HTTPException

from pydantic import BaseModel

app = FastAPI()

class User(BaseModel):

username: str

password: str

users_db = {

"john": User(username="john", password="password123"),

"jane": User(username="jane", password="securepass")

}

def get_current_user(username: str, password: str):

user = users_db.get(username)

if user and user.password == password:

return user

else:

raise HTTPException(status_code=401, detail="Invalid credentials")

@app.get("/users/me")

def read_current_user(username: str, password: str):

return get_current_user(username, password)

```

- Utilize FastAPI's dependency injection system to manage and provide Neo4j driver or session instances to route handlers. This promotes loose coupling, reusability, and testability. Instead of creating drivers directly within route handlers, request them as dependencies.

***Example: get_neo4j_driver dependency in app/db/neo4j_utils.py**

```python

from neo4j import GraphDatabase

from fastapi import Depends

def get_neo4j_driver():

driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password")) # Load from config

try:

yield driver

finally:

driver.close()

Neo4jDriverDependency = Depends(get_neo4j_driver) # Define a type alias for convenience

# app/routers/items.py

from fastapi import APIRouter, Depends

from neo4j import GraphDatabase

from app.db.neo4j_utils import Neo4jDriverDependency

from app.models.items import ItemCreate, Item

router = APIRouter()

@router.post("/items/", response_model=Item)

async def create_item(item: ItemCreate, driver: GraphDatabase.driver = Neo4jDriverDependency):

with driver.session() as session:

# ... use session to create item using Cypher query or OGM ...

# Example (using a service layer for business logic is recommended):

# return item_service.create_item_in_db(session, item)

pass

```

- Use the FastAPI built-in validation and documentation features to automatically validate inputs and generate documentation for your API.

**Good Example:**

```python

from fastapi import FastAPI, Query

app = FastAPI()

@app.get("/items/")

def read_items(q: str = Query(..., min_length = 3, max_length = 50)):

results = search_items(q)

return results

```

***Bad Example:**

```python

from fastapi import FastAPI, Query

app = FastAPI()

@app.get("/items/")

def read_items(q: str):

results = search_items(q)

return results

```

- Design the application with asynchronous operations in mind, especially for database interactions, to leverage FastAPI's concurrency and improve performance. Use async def for route handlers and utilize asynchronous Neo4j drivers and session management where available and beneficial. (Implied by FastAPI's async nature - no direct Airflow analogy, but important for efficient applications)

***Example: Asynchronous route handler and session:**

```python

from fastapi import APIRouter, Depends

from neo4j import GraphDatabase

from app.db.neo4j_utils import Neo4jDriverDependency

router = APIRouter()
