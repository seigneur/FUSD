import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { Theme } from 'react-daisyui'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <Theme dataTheme="cyberpunk">
      <App />
    </Theme>
  </React.StrictMode>
)
