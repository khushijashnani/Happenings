import React, { useReducer } from "react";
import axios from "axios";
import EventContext from "./eventContext";
import EventReducer from "./eventReducer";


const EventState = props => {
    const initialState = {
        userDetails: {},
        events: [],
        loading: true
    };

    const [state, dispatch] = useReducer(EventReducer, initialState);

    const getData = async () => {
        const res = await axios
            .get(
                `https://cors-anywhere.herokuapp.com/https://rpk-happenings.herokuapp.com/ORGANISATION/${sessionStorage.getItem(
                    'organisationid'
                )}`,
                { headers: { Authorization: sessionStorage.getItem('Authorization') } }
            )
            .then((res) => {
                console.log(res);
                // this.assignData(res);
                dispatch({
                    type: "GET_DATA",
                    payload: res.data
                });
            });
    };

    //   const getHelp = async () => {
    //     const res = await axios.get("https://api.rootnet.in/covid19-in/contacts");

    //     dispatch({
    //       type: GET_HELPLINE,
    //       payload: res.data
    //     });
    //   };

    //   const getDailyData = async () => {
    //     const res = await axios.get(
    //       "https://api.rootnet.in/covid19-in/unofficial/covid19india.org/statewise/history"
    //     );
    //     dispatch({
    //       type: GET_DAILY_DATA,
    //       payload: res.data
    //     });
    //   };

    const setLoading = () => dispatch({ type: SET_LOADING });

    return (
        <EventContext.Provider
            value={{

                userDetails: state.userDetails,
                events: state.events,
                setLoading,
                getData
            }}
        >
            {props.children}
        </EventContext.Provider>
    );
};

export default EventState;
