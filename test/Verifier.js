const { expect } = require("chai");
const { poseidonContract: poseidonGenContract } = require("circomlibjs");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

async function deployVerifier() {
  const Verifier = await ethers.getContractFactory("Verifier");
  const verifier = await Verifier.deploy();
  await verifier.deployed();
  return verifier;
}

describe("Evaluate at Zero", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1", async function () {
    expect(await verifier.test_eval_at_zero([1, 1, 1])).to.equal(1);
  });
  it("3x^2 + 2x + 5", async function () {
    expect(await verifier.test_eval_at_zero([5, 2, 3])).to.equal(5);
  });
});

describe("Evaluate at One", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1", async function () {
    expect(await verifier.test_eval_at_one([1, 1, 1])).to.equal(3);
  });
  it("3x^2 + 2x + 5", async function () {
    expect(await verifier.test_eval_at_one([5, 2, 3])).to.equal(10);
  });
});

describe("Evaluate at X", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1, @ x=1", async function () {
    expect(await verifier.test_eval_at_x([1, 1, 1], 1)).to.equal(3);
  });
  it("3x^2 + 2x + 5, @ x=3", async function () {
    expect(await verifier.test_eval_at_x([5, 2, 3], 3)).to.equal(38);
  });
});

describe("derive challenge bits from RO", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("1 field element (1)", async () => {
    const challenge_bits = await verifier.challenge(["0x023f582360b050563925d12615dc5d9b1414cbab8a734f1d3ef5cf1be6b24ada"]);
    expect(challenge_bits)
      .to.equal("0x00000000000000000000000000000000cb12298898c61bef3ca182720e30c6bb");
  });

  it("1 field element (2)", async () => {
    const challenge_bits = await verifier.challenge(["0x1e127bb441507b198a4574b087d2f9880e72a4c3b828914b107fdeb3215c2be4"]);
    expect(challenge_bits)
      .to.equal("0x000000000000000000000000000000009f531dd56d0717fa04b3942829ad8f73");
  });

  it("2 field elements", async () => {
    const challenge_bits = await verifier.challenge([
      "0x374e49d4b4b771764eb2ea9395767c7d361e5eb5eb822dce4e4ec110f09c894a",
      "0x10bdcba6f3b892c9c2bb92a61fb4ea270e5809ea6d555a095abffd7118f71e84",
    ]);
    expect(challenge_bits)
      .to.equal("0x00000000000000000000000000000000a2d60672b4e4716b5ceb8921864bab48");
  });

  it("8 field elements", async () => {
    const challenge_bits = await verifier.challenge([
      "0x2bee180ddc9f66d5eb01d242872dee24ed4b36e711ec517e2b0b2a7065d28902",
      "0x2f6979e989ce7f9c7e785e05f4f369d62eacc21507d30cc24ebda8b94325d445",
      "0x163b85b74f16afbc8f2fa9306acbc5c9ae7fba7af0700599d5bf7fe482cf6911",
      "0x3b6a1ff5e7c962a4fe54179f84ed9d57e1eec33e723daa627d75d85ea04f9856",
      "0x1559de24ce067f6ac3278c58c3860e9b6666be593677db5ef5852d2c12cc71a9",
      "0x11309c6397af03a8249f031c0775bc1783e66f458b92b0aad13c149152b256c9",
      "0x0549210bf45e359c0e9da2d085e13b567021ac1f00c424d7590ebb730d1a61f3",
      "0x2c54d37588e7527ca8d4b61f05d68e492a30be93c5f14a2c07f733cf40295dde",
    ]);
    expect(challenge_bits)
      .to.equal("0x00000000000000000000000000000000d893c12c3110be60d044ae43831c7d14");
  });

});