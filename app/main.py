from fastapi import fastapi
app = FastAPI()

@app.get("/healthz")
def healthz():
    return {"ok": True}