import axios, {AxiosInstance} from "axios";
const clienteHttp: AxiosInstance = axios.create({
    baseURL: "http://localhost:9000/"
});

export default clienteHttp
