pragma solidity ^0.8.17;

import {EllipticCurve} from "./EllipticCurve.sol";

// Defines parameters of Pasta curves as well as some helpful EC utilies for the verifier
library PastaCurves {
    // Primes that define the base fields of the pasta_curves
    // For more details see: https://electriccoin.co/blog/the-pasta-curves-for-halo-2-and-beyond/
    
    // The base field of the Pallas curve is GF(P)
    uint256 public constant P = 28948022309329048855892746252171976963363056481941560715954676764349967630337;
    // The base field of the Vesta curve is GF(Q)
    uint256 public constant Q = 28948022309329048855892746252171976963363056481941647379679742748393362948097;

    // Constants for both pasta curves
    uint256 public constant AA = 0;
    uint256 public constant BB = 5;

    // Generator points for the curves
    uint256 public constant PALLAS_GX = 0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000000;
    uint256 public constant PALLAS_GY = 0x0000000000000000000000000000000000000000000000000000000000000002;
    uint256 public constant PALLAS_GZ = 0x0000000000000000000000000000000000000000000000000000000000000001;

    uint256 public constant VESTA_GX = 0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
    uint256 public constant VESTA_GY = 0x0000000000000000000000000000000000000000000000000000000000000002;
    uint256 public constant VESTA_GZ = 0x0000000000000000000000000000000000000000000000000000000000000001;

    struct JacobianCoordinates {
        uint256 x;
        uint256 y;
        uint256 z;
    }

    struct AffineCoordinates {
        uint256 x;
        uint256 y;
        bool isInfinity;
    }

    function point_on_pallas(uint256 scalar) public pure returns (AffineCoordinates memory){
        (uint256 jx, uint256 jy, uint256 jz) = EllipticCurve.jacMul(scalar, PALLAS_GX, PALLAS_GY, PALLAS_GZ, AA, P);
        (uint256 ax, uint256 ay) = EllipticCurve.toAffine(jx, jy, jz, P);
        return AffineCoordinates(ax, ay, false);
    }

    function point_on_vesta(uint256 scalar) public pure returns (AffineCoordinates memory){
        (uint256 jx, uint256 jy, uint256 jz) = EllipticCurve.jacMul(scalar, VESTA_GX, VESTA_GY, VESTA_GZ, AA, Q);
        (uint256 ax, uint256 ay) = EllipticCurve.toAffine(jx, jy, jz, Q);
        return AffineCoordinates(ax, ay, false);
    }

}