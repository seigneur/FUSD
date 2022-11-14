//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import './SVG.sol';
import './Utils.sol';

contract Renderer {
    function render(uint256 _tokenId, int256 _value) public pure returns (string memory) {
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
                svg.path(
                    string.concat(
                        svg.prop('d', 'M 243.44676,222.01677 C 243.44676,288.9638 189.17548,343.23508 122.22845,343.23508 C 55.281426,343.23508 1.0101458,288.9638 1.0101458,222.01677 C 1.0101458,155.06975 40.150976,142.95572 122.22845,0.79337431 C 203.60619,141.74374 243.44676,155.06975 243.44676,222.01677 z'),
                        svg.prop('fill', '#00FFFF')
                    ),
                    ''

                ),
                svg.text(
                    string.concat(
                        svg.prop('x', '35'),
                        svg.prop('y', '240'),
                        svg.prop('font-size', '22'),
                        svg.prop('fill', 'red')
                    ),
                    string.concat(
                        svg.cdata('Treasury, token #'),
                        utils.uint2str(_tokenId)
                    )
                ),
                svg.text(
                    string.concat(
                        svg.prop('x', '35'),
                        svg.prop('y', '260'),
                        svg.prop('font-size', '15'),
                        svg.prop('fill', 'green')
                    ),
                    string.concat(
                        svg.cdata('Your, current value - '),
                        utils.uint2str(_value)
                    )
                ),
                //the progress bar
                svg.rect(
                    string.concat(
                        svg.prop('fill', '#FFB031'),
                        svg.prop('x', '65'),
                        svg.prop('y', '290'),
                        svg.prop('height', utils.uint2str(7))
                    ),
                    svg.animateAttribute(
                    string.concat(
                        svg.prop('attributeType', 'XML'),
                        svg.prop('attributeName', 'width'),
                        svg.prop('from', utils.uint2str(0)),
                        svg.prop('to', utils.uint2str(100)),
                        svg.prop('dur', '10s'),
                        svg.prop('repeatCount', 'indefinite'),
                        svg.prop('fill', 'freeze')
                    )
                )
                ),
                
               
                '</svg>'
            );
    }

    function example() external pure returns (string memory) {
        return render(1);
    }
    
    
}
