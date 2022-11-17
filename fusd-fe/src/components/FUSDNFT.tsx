import * as React from 'react'
import {
  Button,
  Card
} from "react-daisyui";

export function FUSDNFT() {
return (
  <Card  imageFull>
        <Card.Image
          src="https://api.lorem.space/image/shoes?w=400&h=225"
          alt="Shoes"
        />
        <Card.Body>
          <Card.Title tag="h2">Loan NFT </Card.Title>
          <p></p>
          <Card.Actions className="justify-end">
            <Button color="primary">Repay</Button>
          </Card.Actions>
        </Card.Body>
      </Card>
)
}