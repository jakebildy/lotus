import { Box } from "@mui/material";
import Ellipse from "../assets/Ellipse.png";

type Props = {
  alignRight: boolean | null,
  alt: string,
  src: string,
  height: string,
};


function ImageAndCircle({ src, height = "380px", alignRight, alt }: Props) {
  const _image = (
    <Box paddingTop="20px" paddingLeft="50px" paddingRight="50px" style={{ position: "relative", top: "-200px" }}>


      <img src={src} height={height} alt={alt} style={{ position: "relative" }} />
    </Box>
  );

  if (alignRight)
    return (
      <Box paddingTop="10px" paddingBottom="10px">

        <img src={Ellipse} height="200px" alt={alt} style={{ position: "relative", top: "-70px", right: "-340px" }} />
        {_image}

      </Box>
    );

  return (
    <Box display="flex" flexDirection="row" alignItems="center" justifyContent="center" padding="30px">
      {_image}
    </Box>
  );

}


export default ImageAndCircle;