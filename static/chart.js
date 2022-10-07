const ctx = document.getElementById('logChart').getContext('2d')
const chart = new Chart(ctx, {
  type: 'bar',
  data: {
    labels: ['Errors', 'Warnings'],
    datasets: [{
      label: 'Errors',
      data: [],
      fill: true,
      backgroundColor: [
        'rgba(255, 99, 132, 0.5)',
        'rgba(255, 205, 86, 0.5)'
      ],
      borderColor: [
        'rgb(255, 99, 132)',
        'rgb(255, 205, 86)'
      ],
      borderWidth: 1,
    }]
  },
  options: {
    scales: {
      y: {
        beginAtZero: true,
        max: 30
      }
    }
  }
})

const generateChart = () => {
  const currTime = (Date.now() - (24 * 60 * 60 * 1000)) / 1000
  fetch(`/api/v1/logs/today/${APP_NAME}`)
    .then(d => d.json())
    .then(dataLogs => {
      const data = [dataLogs
        .filter(t => t.severity === 'error').length,
        dataLogs
        .filter(t => t.severity === 'warn').length]

      chart.data.datasets[0].data = data
      chart.update()
  })
}

generateChart()