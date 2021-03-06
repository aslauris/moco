MoCo = {}

MoCo.errorMessage = "%s"

MoCo.css = '
  .moco-compile-error {
    white-space: pre-wrap;
    font-family: Menlo, Monaco, monospace;
    font-size: 14px;
    line-height: 1.5;
    color: black;
    background: white;
    border: 3px solid red;
    border-radius: 5px;
    box-shadow: 5px 5px 15px #CCC;
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    padding: 20px;
    margin: 20px;
    z-index: 10000;
  }
  .moco-compile-error:hover {
    z-index: 10001;
  }
  .moco-compile-error span {
    color: red;
  }
  .moco-compile-error a, .moco-compile-error a:visited {
    color: black;
    text-decoration: none;
  }
  .moco-compile-error a:hover, .moco-compile-error a:active {
    color: red;
    text-decoration: none;
  }
'

MoCo.appendErrorElement = ->
  style = document.createElement('style')
  style.innerHTML = MoCo.css
  pre = document.createElement('pre')
  pre.innerHTML = MoCo.errorMessage
  pre.className = 'moco-compile-error'
  document.body.appendChild(style)
  document.body.appendChild(pre)

window.addEventListener('load', MoCo.appendErrorElement, false)
