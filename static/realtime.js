const APP_NAME = document.getElementById('app-name').innerText
const LOGS = document.getElementById('logs')

const socket = new WebSocket('ws://' + window.location.host + '/ws/')

const getLatestTime = () => {
  return LOGS.children[LOGS.children.length - 1].getAttribute('time')
}

const getSeverityClass = (severity) => {
  switch (severity) {
    case 'error': return 'text-danger'
    case 'info': return 'text-primary'
    case 'warn': return 'text-warning'
    default: return 'text-secondary'
  }
}

const makeLog = (log) => {
  const elem = document.createElement('div')
  elem.className = getSeverityClass(log.severity)
  let date = new Date(log.date * 1000).toISOString()
  elem.innerText = `[${date.substring(0, date.length - 1)}] ${log.severity.toUpperCase()} - ${log.log}`
  elem.setAttribute('time', `${log.date}.`)
  return elem
}

socket.onopen = (e) => {
  // app,since
  setInterval(() => socket.send(`${APP_NAME},${getLatestTime()}`), 1500)
  socket.onmessage = (e) => {
    const data = JSON.parse(e.data)
    let run = false
    data.forEach(t => {
      LOGS.append(makeLog(t))
      run = true
    })

    if (run) generateChart()
  }
}

