import React from "react";
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import { Divider, Drawer, List, ListItem, ListItemIcon } from '@mui/material';
import InboxIcon from '@mui/icons-material/MoveToInbox';
import SettingsIcon from '@mui/icons-material/Settings';
import SupervisorAccountIcon from '@mui/icons-material/SupervisorAccount';
import LogoutIcon from '@mui/icons-material/Logout';
import QueryStatsIcon from '@mui/icons-material/QueryStats';
import Logo from '../../assets/app_icon.png';
import Turtle from '../../assets/0.png';
import { styled } from '@mui/material/styles';
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../Auth";

const DrawerHeader = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  // padding: theme.spacing(0, 1),
  // necessary for content to be below app bar
  ...theme.mixins.toolbar,
}));

const Pages = [

  {
    text: 'Stats',
    icon: <QueryStatsIcon style={{ color: "#9FA2B4" }} />,
    link: '/admin/stats',
  },
  // {
  //   text: 'Report Card Comments',
  //   icon: <CommentIcon style={{ color: "#9FA2B4" }} />,
  //   link: "/report-card-comments",
  // },
  // {
  //   text: 'Resources',
  //   icon: <LightbulbIcon style={{ color: "#9FA2B4" }} />,
  //   link: "/resources",
  // },
  // {
  //   text: 'Planning',
  //   icon: <CreateIcon style={{ color: "#9FA2B4" }} />,
  //   link: '/planning',
  // },
];


export const DashboardDrawer: React.FC<{ selected: string }> = ({ selected }) => {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/");
  };

  function goto(link: string) {
    navigate({ pathname: link })
  }

  return (
    <Drawer
      sx={{
        width: 250,
        // flexShrink: 0,
        '& .MuiDrawer-paper': {
          width: 250,
          boxSizing: 'border-box',
          backgroundColor: "#022b36"
        },
      }}
      variant="persistent"
      anchor="left"
      open={true}
    >
      <DrawerHeader style={{ backgroundColor: "#04a6cf" }}>
        <Box component="img" sx={{ height: 60 }} alt="Logo" src={Logo} />
        <Typography fontSize={28} fontWeight={700} color="white" textAlign={"center"} width={"100%"} >
          Shellevate
        </Typography>
      </DrawerHeader>

      <List>
        {
          Pages.map((page, index) => (
            <ListItem key={page.text} button onClick={() => goto(page.link)} style={{ backgroundColor: page.text === selected ? "#022b36" : "#022b36" }}>
              <ListItemIcon>
                {page.icon}
              </ListItemIcon>
              <Typography color={page.text === selected ? "#DDE2FF" : "#DDE2FF"} fontSize={16}>
                {page.text}
              </Typography>
            </ListItem>
          ))
        }
        <Box height={25} />
      </List>
      <Divider style={{ background: "#4B4C55" }} />
      <List>
        {[
          { text: 'Settings', icon: <SettingsIcon style={{ color: "#9FA2B4" }} /> },
          // { text: 'Subscription', icon: <InboxIcon style={{ color: "#9FA2B4" }} /> }
        ].map((item, index) => (
          <Box key={item.text} bgcolor={item.text === selected ? "#022b36" : "#022b36"}>

            <ListItem button >
              <ListItemIcon>
                {item.icon}
              </ListItemIcon>
              <Typography color={item.text === selected ? "#DDE2FF" : "#A4A6B3"} fontSize={16}>
                {item.text}
              </Typography>
            </ListItem>
          </Box>
        ))}

        <ListItem button onClick={handleLogout}>
          <ListItemIcon>
            <LogoutIcon style={{ color: "#9FA2B4" }} />
          </ListItemIcon>
          <Typography color={"#A4A6B3"} fontSize={16}>
            Logout
          </Typography>
        </ListItem>
      </List>

      <Box component="img" sx={{ marginTop: "10px" }} alt="Turtle" src={Turtle} />

    </Drawer>
  );
}