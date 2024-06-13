const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Dutch Auction Test Script", async function () {
  let addr1, addr2, addr3, addrs, owner, Dutch, dutch;
  beforeEach(async function () {
    Dutch = await ethers.getContractFactory("DutchAuction");
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();

    dutch = await Dutch.deploy();
  });

  describe("Check token price", async function () {
    it("Should verify initial price starts from 5 ethers", async function () {
      const price = await dutch.connect(addr2).price();

      expect(price).to.equal(ethers.parseEther("5"));
    });
  });

  describe("Mint token in an auction", async function () {
    it("Should revert when ethers sent is below price", async function () {
      const ethersSent = { value: ethers.formatEther("2") };
      expect(dutch.connect(addr1).safeMint(4, ethersSent)).to.revertedWith(
        "Invalid ether value sent"
      );
    });

    it("Should revert mint exceed maxSupply", async function () {
      const maxSupply = await dutch.MAXSUPPLY();
      const mintAmount = maxSupply + 1n;

      const price = await dutch.connect(addr2).price();
      const ethersSent = { value: ethers.formatEther(`${price * mintAmount}`) };

      expect(
        dutch.connect(addr1).safeMint(mintAmount, ethersSent)
      ).to.revertedWith("Max supply reached");
    });

    it("Should mint token", async function () {
      const ethersSent = {
        value: ethers.parseEther("5"),
      };
      await dutch.connect(addr2).safeMint(1, ethersSent);

      expect(await dutch.connect(addr1).balanceOf(addr2.address)).to.equal(1);
    });
  });

  describe("Withdraw tokens in treasury", async function () {
    it("Should revert when caller is not contract owner", async function () {
      expect(dutch.connect(addr2).withdraw()).to.be.revertedWithCustomError;
    });

    it("Should revert if treasury is empty", async function () {
      expect(dutch.connect(owner).withdraw()).to.revertedWith(
        "No token in contract"
      );
    });

    it("Should withdraw tokens from treasury", async function () {
      await dutch.connect(addr2).safeMint(1, { value: ethers.parseEther("5") });

      const initialTreasuryBalance = await dutch
        .connect(owner)
        .checkContractBalance();

      await dutch.connect(owner).withdraw();

      expect(await dutch.connect(owner).checkContractBalance()).to.equal(0);
    });
  });

  describe("Transfer token to wallet", async () => {
    const ethFee = { value: ethers.parseEther("5") };

    it("Should transfer token to wallet", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await dutch.connect(addr1).transferFrom(addr3.address, 1);

      expect(await dutch.connect(addr1).ownerOf(1)).to.equal(addr3.address);
    });
    it("Should safe-transfer token to wallet", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await dutch.connect(addr1).safeTransferFrom(addr3.address, 1);

      expect(await dutch.connect(addr1).ownerOf(1)).to.equal(addr3.address);
    });

    it("Should revert if caller is not token owner", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await expect(
        dutch.connect(addr2).safeTransferFrom(addr3.address, 1)
      ).to.revertedWith("ERC721: transfer caller is not owner or approved");
    });
  });

  describe("Approve, and verify and spend tokens on behalf of owner", async () => {
    const ethFee = { value: ethers.parseEther("5") };

    it("Should approve a spender", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await dutch.connect(addr1).approve(addr2.address, 1);

      expect(await dutch.getApproved(1)).to.equal(addr2.address);
    });

    it("Should verify approved address", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await dutch.connect(addr1).approve(addr2.address, 1);

      expect(await dutch.getApproved(1)).to.equal(addr2.address);
    });

    it("Should set approval for all tokens", async () => {
      await dutch.connect(addr1).safeMint(1, ethFee);
      await dutch.connect(addr1).setApprovalForAll(addr3.address, true);

      expect(
        await dutch
          .connect(addr1)
          .isApprovedForAll(addr1.address, addr3.address)
      ).to.equal(true);
    });
  });
});
