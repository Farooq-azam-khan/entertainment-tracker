import { Elm } from './Main.elm'


const node = document.querySelector('#elm-container')
if (node) {
  const app = Elm.Main.init({ node })
}
