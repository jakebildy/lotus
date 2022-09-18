import { Box, Container, Typography } from "@mui/material";
import Nav from "./Nav";
import FitsVideo from "../assets/FitsVideo2.gif";

type Props = {
  title: string,
  subtitle: string,
  imgUrl: string,
  circleColor: string,
  page: string,
};

const BackgroundContainer = ({ title, subtitle, imgUrl, circleColor, page }: Props) => (
  <Box height="100vh" style={{ backgroundImage: `url(${imgUrl})`, backgroundSize: 'cover' }}>
    <Nav page={page} />
    <Container>
      <Box display="flex" flexDirection="row" padding="30px">
        <Box paddingTop="200px" style={{ position: "relative" }}>

          <Typography style={{
            position: "relative",

            color: page === "HOME" ? "red" : circleColor === "white" ? "black" : "white",
            fontSize: "60px",
            zIndex: 2,
          }}>
            {title}
          </Typography>
          <Typography paddingTop="60px" style={{
            position: "relative",
            width: "650px",
            color: page === "HOME" ? "black" :
              circleColor === "white" ? "white" : "white",
            fontSize: "18px",
            zIndex: 2,


          }}>
            {subtitle}
          </Typography>
          <div style={{
            position: "relative",
            // top: `calc(100%)`,
            top: "-260px",
            left: "-60px",
            display: "flex",
            width: "150px",
            height: "150px",
            backgroundColor: page === "HOME" ? "#DDDDDD" : circleColor,
            borderRadius: "50%",
            border: page === "HOME" ? "2px solid white" : "0px",
            zIndex: 0,
          }} />
        </Box>
        {page === "HOME" ? <Box paddingTop="50px" paddingLeft="50px">
          <img src={FitsVideo} height={"480px"} alt="Fits" style={{ borderRadius: "45px" }} />
        </Box> : <Box></Box>}
        <Box />
      </Box>
    </Container>
  </Box >
);


export default BackgroundContainer;