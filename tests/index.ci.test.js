// tests/index.ci.test.js
import app from "../src/app.js";
import request from "supertest";

describe("Stateless CI Tests", () => {
  it("should respond with a welcome message", async () => {
    const res = await request(app).get("/");
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual({ message: "welcome to my api" });
  });
});
