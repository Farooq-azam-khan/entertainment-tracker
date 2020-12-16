import { Elm } from './Main.elm'


const node = document.querySelector('#elm-container')
if (node) {
  Elm.Main.init({ node })
}
