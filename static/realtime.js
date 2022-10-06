const APP_NAME = document.getElementById('app-name').innerText
const ORIG_TIME = document.getElementById

const socket = new WebSocket('ws://' + window.location.host + '/ws/')

socket.onopen = (e) => {
  // app,since
  setInterval(() => socket.send(`${APP_NAME},`), 1000)

  socket.onmessage = (e) => {
    const data = JSON.parse(e.data)
    data.forEach(t => {
      
    })
  }
}

