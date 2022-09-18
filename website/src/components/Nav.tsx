import { Link } from 'react-router-dom';
import { AppBar, Toolbar, Box, Typography, Divider } from '@mui/material';
import Logo from "../assets/FITS.png";

const appbarStyle = {
  // background: '#00000000',
  // height: "100px",
  background: '#00000000',
};

type Props = {
  page: string,
};

function Nav({ page }: Props) {
  return (
    // <AppBar position="fixed" style={appbarStyle} elevation={1}>
    <Box>

      <AppBar position="relative" style={appbarStyle} elevation={0}>
        <Toolbar>
          <Box flexGrow={1} />
          <Link to="/"><Box component="img" sx={{ height: 30 }} alt="Fit" src={Logo} /></Link>

          <Box flexGrow={1} />

          <Divider orientation="vertical" color="black" style={{ height: "65px" }} />
          <Box flexGrow={0.3} />
          <Typography paddingRight={"10px"}><Link style={{
            color: 'black', textDecoration: page === "BRANDS" ? "line-through" : 'none',
            textDecorationColor: page === "BRANDS" ? "red" : ""
          }} to="/brands">BRANDS</Link></Typography>
          <Box width="60px" />
          <Typography paddingRight={"10px"}><Link style={{
            color: 'black',
            textDecoration: page === "STYLISTS" ? "line-through" : 'none', textDecorationColor: page === "STYLISTS" ? "red" : ""
          }} to="/stylists/">STYLISTS</Link></Typography>
          <Box flexGrow={0.3} />
          <Divider orientation="vertical" color="black" style={{ height: "65px" }} />

          <Box flexGrow={1.5} />
          {/* <Link2 href="/download" underline="none">
            <Button
              variant="contained"
              style={{
                width: "130px",
                border: '1px solid',
                borderColor: '#000000',
                background: '#000000',
                // borderRadius: '200px',
                textTransform: 'none'
              }}
            >
              <Typography style={{ color: '#ffffff', fontWeight: "bold" }}>Login</Typography>
            </Button>
          </Link2> */}
          <Box flexGrow={1} />
        </Toolbar>
      </AppBar>
      <Divider color="black" />
    </Box>
  );
}

export default Nav;