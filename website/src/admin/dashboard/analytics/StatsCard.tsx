import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import { Card } from "@mui/material";

import React from "react";
import { useNavigate } from "react-router-dom";
import { Line } from "@ant-design/plots";
import './bouncing_text.css';

export function StatsCard(props: {
  text: string;
  count: Number;
  percentRetained: Number;
  percentRetainedMonth: Number;
  avgLifetime: Number;
  link: string | null;
}) {
  const navigate = useNavigate();
  React.useEffect(() => {
    async function fetch() {
      try {
      } catch (error) {
        console.log(error);
      }
    }
    fetch();
  }, []);

  return (
    <Box width={"1600px"} height={"300px"} padding="10px" flexDirection={"row"} display="flex">
      <Card
        onClick={() => {
          if (props.link) navigate(props.link);
        }}
      >
        <Box width={"300px"} height={"300px"} color={"white"} style={{ backgroundColor: "#04a6cf" }}>
          <Typography textAlign={"center"} fontSize={20} paddingTop="25px">
            {props.text}
          </Typography>
          <Typography
            textAlign={"center"}
            fontSize={32}
            fontWeight={600}
            paddingTop={"10px"}
          >
            <div className="bouncingText" style={{ marginLeft: "65px", marginTop: "20px" }}>
              <div className="b">
                {props.count.toString().split('')[0]}
              </div>
              <div className="o">
                {props.count.toString().slice(1)}
              </div>
            </div>
          </Typography>
        </Box>
      </Card>

      <Card style={{ marginLeft: "20px" }}>
        <Box width={"300px"} height={"300px"}>
          <img style={{ minWidth: "300px", minHeight: "300px", marginLeft: "0px", marginTop: "0px" }} src="https://static.wikia.nocookie.net/surrealmemes/images/f/f8/MemeManSitt.jpg"></img>
        </Box>
      </Card>

      <Card
        style={{ marginLeft: "20px" }}
        onClick={() => {
          if (props.link) navigate(props.link);
        }}
      >
        <Box width={"300px"} height={"300px"} color={"white"} style={{ backgroundColor: "black" }}>
          <Typography textAlign={"center"} fontSize={20} paddingTop="25px">
            Percent of users with accounts retained after one week
          </Typography>
          <Typography
            textAlign={"center"}
            fontSize={32}
            fontWeight={600}
            paddingTop={"10px"}
          >
            <div className="bouncingText" style={{ marginLeft: "60px", marginTop: "20px", fontSize: "50px" }}>
              <div className="b">
                {props.percentRetained.toString()}
              </div>
              <div className="o">
                %
              </div>
            </div>
          </Typography>
        </Box>
      </Card>
      {/* 
      <Card
      style={{marginLeft: "20px"}}
        onClick={() => {
          if (props.link) navigate(props.link);
        }}
      >
        <Box width={"300px"} height={"300px"} color={"white"} style={{backgroundColor:"black"}}>
          <Typography textAlign={"center"} fontSize={20} paddingTop="25px" fontFamily={"Termina"}>
            Percent of users with accounts retained after one month
          </Typography>
          <Typography
            textAlign={"center"}
            fontSize={32}
            fontWeight={600}
            paddingTop={"10px"}
          >
            <div className="bouncingText" style={{marginLeft: "60px", marginTop: "20px", fontSize: "50px"}}>
              <div className="b">
              {props.percentRetainedMonth.toString()}
              </div>
              <div className="o">
              %
              </div>
              </div>
          </Typography>
        </Box>
      </Card> */}

      <Card
        style={{ marginLeft: "20px" }}
        onClick={() => {
          if (props.link) navigate(props.link);
        }}
      >
        <Box width={"300px"} height={"300px"} color={"white"} style={{ backgroundColor: "black" }}>
          <Typography textAlign={"center"} fontSize={20} paddingTop="25px">
            Average Lifetime of Users with Accounts in Weeks
          </Typography>
          <Typography
            textAlign={"center"}
            fontSize={32}
            fontWeight={600}
            paddingTop={"10px"}
          >
            <div className="bouncingText" style={{ marginLeft: "100px", marginTop: "20px", fontSize: "50px" }}>
              <div className="b">
                {props.avgLifetime.toString()}
              </div>
            </div>
          </Typography>
        </Box>
      </Card>


    </Box>
  );
}

export function GraphCard(props: {
  title: string;
  data: { _id: string; dau?: number, mau?: number }[];
  xField: string;
  yField: string;

  link: string | null;
}) {
  const navigate = useNavigate();
  const config = {
    data: props.data,
    xField: props.xField,
    yField: props.yField,
    label: {},
    point: {
      size: 5,
      shape: "diamond",
      style: {
        fill: "white",
        stroke: "#5B8FF9",
        lineWidth: 2,
      },
    },
    tooltip: {
      showMarkers: false,
    },
    state: {
      active: {
        style: {
          shadowBlur: 4,
          stroke: "#000",
          fill: "red",
        },
      },
    },
    interactions: [
      {
        type: "marker-active",
      },
    ],
    autoFit: true,
  };
  // return <Line {...config} />;

  return (
    <Box width={"400px"} height={"200px"} padding="10px">
      <Card
        onClick={() => {
          if (props.link) navigate(props.link);
        }}
      >
        <Typography textAlign={"center"} fontSize={20} paddingTop="10px" paddingBottom={"10px"}>
          {props.title}
        </Typography>
        <Box width={"400px"} height={"200px"} padding="10px">
          <Line {...config} />
        </Box>
      </Card>
    </Box>
  );
}
