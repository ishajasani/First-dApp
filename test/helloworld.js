const HelloWorld = artifacts.require("HelloWorld");
contract("HelloWorld", () => {
  it("Testing", async () => {
    const instance = await HelloWorld.deployed();
    await instance.setMessage("Hello IJ");
    const message = await instance.message();
    assert.equal(message, "Hello IJ");
  });
});
