pragma solidity ^0.8.17;
import {SumCheck} from "./SumCheck.sol";

contract Verifier {
    function testMult(uint a, uint b) public pure returns (uint) {
        return SumCheck.mult(a, b);
    }
}

