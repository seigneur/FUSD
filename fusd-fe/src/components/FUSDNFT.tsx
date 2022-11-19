import * as React from 'react'
import {
  Button,
  Card,
  Link
} from "react-daisyui";
import { ApproveRepayFUSD } from './ApproveRepayFUSD';
import { ApproveRepayNFT } from './ApproveRepayNFT';
import { Repay } from './Repay';

interface FUSDNFTOBJ {
  tokenId:string;
  value:string;
}
export function FUSDNFT(fusdobjInst:FUSDNFTOBJ) {
  const svgStr = '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400"><path d="M 243.44676,222.01677 C 243.44676,288.9638 189.17548,343.23508 122.22845,343.23508 C 55.281426,343.23508 1.0101458,288.9638 1.0101458,222.01677 C 1.0101458,155.06975 40.150976,142.95572 122.22845,0.79337431 C 203.60619,141.74374 243.44676,155.06975 243.44676,222.01677 z" fill="#00FFFF" ></path><text x="35" y="240" font-size="22" fill="red" ><![CDATA[Treasury, token #]]>'+fusdobjInst.tokenId+'</text><text x="35" y="260" font-size="15" fill="green" ><![CDATA[]]> $'+fusdobjInst.value+'</text><rect fill="#FFB031" x="65" y="290" height="7" ><animate attributeType="XML" attributeName="width" from="0" to="100" dur="10s" repeatCount="indefinite" fill="freeze" /></rect></svg>';
  const svg = new Blob([svgStr], { type: "image/svg+xml" });
  const url = URL.createObjectURL(svg);

  return (
  <Card  imageFull>
        <Card.Image
          src={url}
          alt="Loan"
        />
        <Card.Body>
          <Card.Title tag="h2">Loan NFT </Card.Title>
          <p></p>
          <Card.Actions className="justify-end">
            {/* <Button color="primary"><ApproveRepayFUSD /></Button>
            <Button color="primary"><ApproveRepayNFT /></Button> */}
            <Button color="primary"><Repay  tokenId={"0"}/></Button>

            <Link href="https://testnets.opensea.io/assets/goerli/0x856d3df560badc083ea15933b8947e02b501803c/0" target="_blank" className="btn btn-secondary">NFT</Link>
          </Card.Actions>
        </Card.Body>
      </Card>
)
}