


import store from '../../Store'

import React, { Component } from 'react'

class PieChart extends Component {
    constructor(props) {
        super(props)
        this.state = {
            labels: store.getState().pieData.labels,
            datasets: [
                {
                    backgroundColor: [
                        'rgba(82,98,255,0.75)',
                        'rgba(46,198,255,0.75)',
                        'rgba(123,201,82,0.75)',
                        'rgba(255,171,67,0.75)',
                        'rgba(252,91,57,0.75)',
                        'rgba(139,135,130,0.75)',
                    ],
                    label: "My First dataset",
                    fill: true,
                    // backgroundColor: gradientStroke,
                    borderColor: "#ffffff",
                    borderWidth: 1,
                    borderDash: [],
                    borderDashOffset: 0.0,
                    pointBackgroundColor: "#1f8ef1",
                    pointBorderColor: "rgba(255,255,255,0)",
                    pointHoverBackgroundColor: "#1f8ef1",
                    pointBorderWidth: 20,
                    pointHoverRadius: 4,
                    pointHoverBorderWidth: 15,
                    pointRadius: 4,

                    data: store.getState().pieData.data
                }
            ]
        }
        store.subscribe(() => {
            this.setState({
                ...this.state,
                labels: store.getState().pieData.labels,
                datasets: [
                    {
                        backgroundColor: [
                            'rgba(82,98,255,0.75)',
                            'rgba(46,198,255,0.75)',
                            'rgba(123,201,82,0.75)',
                            'rgba(255,171,67,0.75)',
                            'rgba(252,91,57,0.75)',
                            'rgba(139,135,130,0.75)',
                        ],
                        label: "My First dataset",
                        fill: true,
                        // backgroundColor: gradientStroke,
                        borderColor: "#ffffff",
                        borderWidth: 1,
                        borderDash: [],
                        borderDashOffset: 0.0,
                        pointBackgroundColor: "#1f8ef1",
                        pointBorderColor: "rgba(255,255,255,0)",
                        pointHoverBackgroundColor: "#1f8ef1",
                        pointBorderWidth: 20,
                        pointHoverRadius: 4,
                        pointHoverBorderWidth: 15,
                        pointRadius: 4,

                        data: store.getState().pieData.data
                    }
                ]
            })
        })
    }
    render() {
        return (
            <div>

            </div>
        )
    }
}




export default pieData