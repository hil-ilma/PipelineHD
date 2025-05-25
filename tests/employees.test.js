import request from "supertest";
import app from "../src/app";
import { pool } from "../src/db";

let insertedId;

describe("Employees Routes", () => {
  beforeAll(async () => {
    // Ensure an employee exists with id = 1 (or capture the inserted ID)
    const res = await request(app).post("/api/employees").send({
      name: "Jane Doe",
      salary: 9999,
    });
    insertedId = res.body.id; // save for later delete/get
  });

  it("should respond a list of employees", async () => {
    const res = await request(app).get("/api/employees");
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: expect.any(Number),
          name: expect.any(String),
          salary: expect.any(Number),
        }),
      ])
    );
  });

  it("should create a new employee", async () => {
    const res = await request(app).post("/api/employees").send({
      name: "John Doe",
      salary: 1000,
    });
    expect(res.statusCode).toEqual(201);
    expect(res.body).toEqual(
      expect.objectContaining({
        id: expect.any(Number),
        name: "John Doe",
        salary: 1000,
      })
    );
  });

  it("should get an employee by id", async () => {
    const res = await request(app).get(`/api/employees/${insertedId}`);
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual(
      expect.objectContaining({
        id: insertedId,
        name: expect.any(String),
        salary: expect.any(Number),
      })
    );
  });

  it("should delete an employee by id", async () => {
    const res = await request(app).delete(`/api/employees/${insertedId}`);
    expect(res.statusCode).toEqual(204);
  });

  afterAll(async () => {
    await pool.end();
  });
});
