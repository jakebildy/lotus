import { Box, Typography } from "@mui/material";

type Props = {
  alignRight: boolean | null,
  title: string,
  text: string,
  img: string,
  imageHeight: string,
};

function ImageAndText({ title, text, img, imageHeight = "380px", alignRight }: Props) {
  const _image = (
    <Box paddingTop="20px" paddingLeft="50px" paddingRight="50px">
      <img src={img} height={imageHeight} alt={title} />
    </Box>
  );
  const _text = (
    <Box maxWidth="400px" paddingTop="20px" paddingLeft="50px" paddingRight="50px">
      <Typography variant="h6" fontWeight={800}>{title}</Typography>
      <Typography paddingTop="10px" >{text}</Typography>
    </Box>
  );
  if (alignRight)
    return (
      <Box display="flex" flexDirection="row" alignItems="center" justifyContent="center" paddingTop="10px" paddingBottom="10px">
        {_image}
        {_text}
      </Box>
    );

  return (
    <Box display="flex" flexDirection="row" alignItems="center" justifyContent="center" padding="30px">
      {_text}
      {_image}
    </Box>
  );

}


export default ImageAndText;