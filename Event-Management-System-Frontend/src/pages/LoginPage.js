
import React from "react";
import axios from 'axios'
import {
    Button,
    Card,
    CardHeader,
    CardBody,
    CardFooter,
    CardText,
    FormGroup,
    Form,
    Input,
    Row,
    Col,
    Container
} from "reactstrap";
import { Redirect } from "react-router-dom";
import Lottie from 'react-lottie';
import * as happeningslogin from '../animations/happeningslogin.json';
import * as happeningsloading from '../animations/happeningsloading.json';
const logo = {
    loop: true,
    autoplay: true,
    animationData: happeningslogin.default,
    rendererSettings: {
        preserveAspectRatio: 'xMidYMid slice',
    },
};
const loadingjson = {
    loop: true,
    autoplay: true,
    animationData: happeningsloading.default,
    rendererSettings: {
        preserveAspectRatio: 'xMidYMid slice',
    },
};
class LoginPage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            loginPassword: '',
            loginUsername: '',
            loginSuccess: false,
            token: '',
            name: '',
            id: 0,
            loading: false,
        };
    }
    signInUser = async () => {
        this.setState({ ...this.state, loading: true });

        let user = {
            username: this.state.loginUsername,
            password: this.state.loginPassword,
            type: "ORGANISATION"
        };

        console.log(user);
        const res = await axios
            .post(
                'https://cors-anywhere.herokuapp.com/https://rpk-happenings.herokuapp.com/login',
                user
            )
            .then((response) => {
                console.log(response);
                sessionStorage.removeItem('Authorization');
                sessionStorage.removeItem('organisationid');
                sessionStorage.setItem(
                    'Authorization',
                    `Bearer ${response.data.access_token}`
                );
                sessionStorage.setItem('organisationid', response.data.id);
                setTimeout(() => {
                    console.log('Delay');
                    this.setState({
                        ...this.state,
                        token: `Bearer ${response.data.access_token}`,
                        loginSuccess: true,
                        name: response.data.name,
                        id: response.data.id,
                    });
                }, 4000);
            })
            .catch((err) => {
                console.log(err);
            });
    };
    activateMode = mode => {
        switch (mode) {
            case "light":
                document.body.classList.add("white-content");
                break;
            default:
                document.body.classList.remove("white-content");
                break;
        }
    };
    render() {
        if (this.state.loginSuccess) {
            console.log(this.state.loginSuccess);

            return (
                <Redirect
                    to={{
                        pathname: '/admin/dashboard',
                        state: {
                            access_token: this.state.token,
                            name: this.state.name,
                            id: this.state.id,
                        },
                    }}
                />
            );
        }
        return (
            <>

                <div className="content" style={{
                    position: 'absolute', left: '50%', top: '50%',
                    transform: 'translate(-50%, -50%)'
                }}>
                    <Container className='mt--8 pb-5'>

                        <Row className='justify-content-center'>
                            <Col md='11'>
                                <Card className="card-user">
                                    <CardBody>

                                        <CardText />
                                        <div className="author">
                                            <div className="block block-one" />
                                            <div className="block block-two" />
                                            <div className="block block-three" />
                                            <div className="block block-four" />




                                            <h2 className="title"><Lottie options={logo} height={60} width={60} />Happenings</h2>




                                            {/* <p className="title">Sign In</p> */}
                                        </div>
                                        <Form>
                                            <Row>
                                                <Col md="12">
                                                    <FormGroup>
                                                        <label>Username</label>
                                                        <Input


                                                            placeholder="Username"
                                                            type="text"
                                                            onChange={(e) => {

                                                                this.setState({
                                                                    ...this.state,
                                                                    loginUsername: e.target.value,
                                                                });
                                                            }}
                                                        />
                                                    </FormGroup>

                                                </Col>

                                                <Col>
                                                    <FormGroup>
                                                        <label>Password</label>
                                                        <Input

                                                            placeholder="Password"
                                                            type="password"
                                                            onChange={(e) => {

                                                                this.setState({
                                                                    ...this.state,
                                                                    loginPassword: e.target.value,
                                                                });
                                                            }}
                                                        />
                                                    </FormGroup>
                                                </Col>
                                            </Row>
                                        </Form>
                                    </CardBody>
                                    <CardFooter className='mb-5'>
                                        <div className="button-container">

                                            {!this.state.loading ? (
                                                <Button className="btn-fill btn-block" color="primary" type="button" onClick={this.signInUser}
                                                    disabled={this.state.loading}>
                                                    Sign In
                                                </Button>
                                            ) : (
                                                    <Lottie options={loadingjson} height={45} width={45} />
                                                )}

                                        </div>
                                    </CardFooter>

                                </Card>
                                {/* </Col> */}
                            </Col>
                        </Row>
                    </Container>
                </div >
            </>
        );
    }
}

export default LoginPage;
