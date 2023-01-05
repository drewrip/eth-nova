pragma solidity ^0.8.17;

contract PoseidonUnit2 {
    function poseidon(uint256[2] memory) public view returns (uint256) {}
}

contract PoseidonUnit3 {
    function poseidon(uint256[3] memory) public view returns (uint256) {}
}

contract PoseidonUnit24 {
    function poseidon(uint256[24] memory) public view returns (uint256) {}
}

contract Poseidon {
    PoseidonUnit2 _poseidonUnit2;
    PoseidonUnit3 _poseidonUnit3;
    PoseidonUnit24 _poseidonUnit24;

    uint arity = 24;

    constructor(address _poseidon2ContractAddr, address _poseidon3ContractAddr, address _poseidon24ContractAddr)
    {
        _poseidonUnit2 = PoseidonUnit2(_poseidon2ContractAddr);
        _poseidonUnit3 = PoseidonUnit3(_poseidon3ContractAddr);
        _poseidonUnit24 = PoseidonUnit24(_poseidon24ContractAddr);
    }

    function hash2(uint256[2] memory inp) public view returns (uint256) {
        return _poseidonUnit2.poseidon(inp);
    }

    function hash3(uint256[3] memory inp) public view returns (uint256) {
        return _poseidonUnit3.poseidon(inp);
    }

    function hash24(uint256[24] memory inp) public view returns (uint256) {
        return _poseidonUnit24.poseidon(inp);
    }

    //  Nova uses neptune's SAFE API to realize an RO using Poseidon, so
    //  this function should produce the same field element when "squeezed" as the
    //  Sponge Nova uses. There are no current plans to extend this to a more
    //  generic implementation of neptune's SpongeAPI. Since Nova uses it
    //  with one specific IOPattern that is parameterized by the initial num_absorbs
    //  we can effectively hard code some constants as they appear in Nova.
    //    For more details on the SAFE API, see: 
    //    https://hackmd.io/bHgsH6mMStCVibM_wYvb2w#25-Internal-API-recommendation
    function spongeAbsorbSqueeze(uint256[] memory elements, uint256 num_absorbs) public view returns (uint256) {
        // Simple IOPattern representing absorbing num_absorb field elements and squeezing once at the end
        uint rate = arity;
        uint256[] memory state = new uint256[](arity);
        uint256 tag = hash2([0x80000000 + num_absorbs, 0x00000001]);
        state[0] = tag;
        uint absorb_pos = 1;
        for(uint i = 0; i < elements.length; i++){
            if(absorb_pos >= rate){
                
            }
        }

        return 0;

    }
}

library PoseidonUnit1L {
    function poseidon(uint256[1] memory) public view returns (uint256) {}
}

library PoseidonUnit2L {
    function poseidon(uint256[2] memory) public view returns (uint256) {}
}

library PoseidonUnit3L {
    function poseidon(uint256[3] memory) public view returns (uint256) {}
}