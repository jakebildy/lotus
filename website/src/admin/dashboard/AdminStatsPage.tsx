import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import { Card, ListItem } from '@mui/material';
import { DashboardDrawer } from './DashboardDrawer';
// import Nav from '../../components/Nav';
import React from 'react';
import { useNavigate } from 'react-router-dom';
import Api from '../../Api';
import { GraphCard, StatsCard } from './analytics/StatsCard';

function diff_weeks(dt2: string, dt1: string) {
  const d1 = new Date(dt1);
  const d2 = new Date(dt2);

  var diff = (d2.getTime() - d1.getTime()) / 1000;
  diff /= (60 * 60 * 24 * 7);
  return Math.abs(Math.round(diff));

}

export function AdminStatsPage() {
  const navigate = useNavigate();
  const [userCount, setUserCount] = React.useState(0);
  const [percentRetained, setPercentRetained] = React.useState(0.0);
  const [percentRetainedMonth, setPercentRetainedMonth] = React.useState(0.0);
  const [avgLifetime, setAvgLifetime] = React.useState(0.0);
  const [dauCount, setDauCount] = React.useState(0);
  const [dauData, setDauData] = React.useState<{ _id: string, dau: number }[]>([]);
  const [wauData, setWauData] = React.useState<{ _id: string, wau: number }[]>([]);
  const [mauData, setMauData] = React.useState<{ _id: string, mau: number }[]>([]);
  const [userFrequencyData, setUserFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [tagFrequencyData, setTagFrequencyData] = React.useState<any>({});
  const [outfitsScrolledOnFrequencyData, setOutfitsScrolledOnFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [addToCartFrequencyData, setAddToCartFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [itemsClickedOnFrequenceData, setItemsClickedOnFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [outfitGeneratedFrequencyData, setOutfitGeneratedFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [brandsPageVisitedFrequencyData, setBrandsPageVisitedFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [checkoutButtonPressedFrequencyData, setCheckoutButtonPressedFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [pinPressedFrequencyData, setPinPressedFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [userLikeFrequencyData, setUserLikeFrequencyData] = React.useState<{ _id: string, freq: number }[]>([]);
  const [shoppingCartFrequencyData, setShoppingCartEventFreq] = React.useState<{ _id: string, freq: number }[]>([]);
  const [salesSundayPressedFrequencyData, setSalesSundayPressedFreq] = React.useState<{ _id: string, freq: number }[]>([]);

  const replaceUserIdsWithNames = (freq: any, users: any[]) => {
    for (const f in freq) {
      for (const u in users) {
        //@ts-ignore
        if (freq[f]["_id"] === users[u]["_id"]) {
          //@ts-ignore
          freq[f]["_id"] = users[u]["fullName"];
        }
      }
    }

    return freq;
  }

  React.useEffect(() => {
    async function fetch() {
      try {
        const users = await Api.analytics.getUsers();
        setUserCount(users.length);

        const dau = await Api.analytics.getDau("login");
        setDauData((dau as [{ _id: string, dau: number }]).sort((a, b) => a._id.localeCompare(b._id)));

        const wau = await Api.analytics.getWau("login");
        console.log("WAU")
        console.log(wau);
        setWauData((wau as [{ _id: string, wau: number }]).sort((a, b) => a._id.localeCompare(b._id)));

        const mau = await Api.analytics.getMau("login");
        console.log("MAU")
        console.log(mau);
        setMauData((mau as [{ _id: string, mau: number }]).sort((a, b) => a._id.localeCompare(b._id)));

        const all = await Api.analytics.getAll("login");
        console.log("ALL")
        console.log(all);

        let activeUsers: any = {}

        for (const i in all) {
          if (activeUsers[all[i]['user']] === undefined) {
            activeUsers[all[i]['user']] = {};
            activeUsers[all[i]['user']]['first'] = all[i]['createdAt'];
            activeUsers[all[i]['user']]['last'] = all[i]['createdAt'];
          } else {
            if ((Date.parse(activeUsers[all[i]['user']]['first'])) > Date.parse((all[i]['createdAt']))) {
              activeUsers[all[i]['user']]['first'] = all[i]['createdAt'];
            } else if ((Date.parse(activeUsers[all[i]['user']]['last'])) < Date.parse((all[i]['createdAt']))) {
              activeUsers[all[i]['user']]['last'] = all[i]['createdAt'];
            }

          }

        }

        for (const i2 in activeUsers) {
          activeUsers[i2]["weekRetained"] = diff_weeks(activeUsers[i2]['first'], activeUsers[i2]['last']);
        }

        let percentageRetainedAfterWeek = 0.0;
        let percentageRetainedAfterMonth = 0.0;

        let tooNew = 0;
        let tooNewMonth = 0;

        let avgLifetime = 0;

        for (const i2 in activeUsers) {

          if (diff_weeks(activeUsers[i2]["first"], Date().toString()) <= 0) {
            console.log("!!");
            tooNew += 1;
            tooNewMonth += 1;
          } else {
            avgLifetime += activeUsers[i2]["weekRetained"];

            if (diff_weeks(activeUsers[i2]["first"], Date().toString()) <= 4) {
              console.log("!!");
              tooNewMonth += 1;
            }
            else {
              percentageRetainedAfterMonth += (activeUsers[i2]["weekRetained"] > 4 ? 1 : 0);
            }
            percentageRetainedAfterWeek += (activeUsers[i2]["weekRetained"] >= 1 ? 1 : 0);

          }
        }
        console.log(percentageRetainedAfterWeek);
        console.log(Object.keys(activeUsers).length);
        avgLifetime = avgLifetime / ((Object.keys(activeUsers).length - tooNew));
        percentageRetainedAfterWeek = percentageRetainedAfterWeek / ((Object.keys(activeUsers).length - tooNew));
        percentageRetainedAfterMonth = percentageRetainedAfterMonth / ((Object.keys(activeUsers).length - tooNewMonth));
        console.log(tooNewMonth)
        console.log(percentageRetainedAfterMonth);
        setPercentRetained(Math.round(percentageRetainedAfterWeek * 1000) / 10);
        setPercentRetainedMonth(Math.round(percentageRetainedAfterMonth * 1000) / 10);
        setAvgLifetime(Math.round(avgLifetime * 10) / 10)
        // setAllData((all as [{ _id: string, mau: number }]).sort((a, b) => a._id.localeCompare(b._id)));


        const outfits = await Api.outfits.getAll();
        let tagFreq: any = {};

        for (const outfit in outfits) {
          if (outfits[outfit].tags !== "") {
            const tags = outfits[outfit].tags.split(",");
            for (const tag in tags) {
              if (!tagFreq[tags[tag]]) {
                tagFreq[tags[tag]] = 0;
              }
              tagFreq[tags[tag]] += 1;
              //   tagFreq.push({ tag: tags[tag], freq: 1 });
            }
          }
        }
        setTagFrequencyData(tagFreq);

        //Login
        let freq = await Api.analytics.getFreq("login");
        freq = replaceUserIdsWithNames(freq, users);
        setUserFrequencyData(((freq as [{ _id: string, freq: number }])
          .sort((a, b) => (b.freq > a.freq ? 1 : -1))));

        // Outfits Scrolled On
        let outfitsScrolledOnFreq = await Api.analytics.getFreq("OUTFIT_SCROLL_EVENT");
        outfitsScrolledOnFreq = replaceUserIdsWithNames(outfitsScrolledOnFreq, users);
        setOutfitsScrolledOnFrequencyData(((outfitsScrolledOnFreq as [{ _id: string, freq: number }])
          .sort((a, b) => (b.freq > a.freq ? 1 : -1))));



      }
      catch (error) {
        console.log(error);
      }
    }

    fetch();
  }, []);

  return (

    <Box
      width="100vw" flexGrow={1}
      bgcolor={"#F7F8FC"}
      display="flex" flexDirection="row"
    >

      {/* <Nav /> */}
      <DashboardDrawer selected='Stats' />
      <Box flexGrow={1} display="flex" flexDirection={"column"} padding="30px">

        {/* Title */}
        <Typography fontWeight={500} fontSize={24} paddingBottom="15px">App Analytics 🐢🚀</Typography>

        {/* Page Body */}
        <Box flexGrow={1} paddingTop="15px">

          <StatsCard text={"Users"} count={userCount}
            percentRetained={percentRetained}
            percentRetainedMonth={percentRetainedMonth}
            avgLifetime={avgLifetime}
            link={null}></StatsCard>
          {/* <StatsCard text={"DAU"} count={dauCount} link={null}></StatsCard> */}

          <Box flexDirection={"row"} display="flex">
            <GraphCard title={"DAU (Daily Active Users)"} data={dauData} xField={"_id"} yField={"dau"} link={null}></GraphCard>
            <GraphCard title={"WAU (Weekly Active Users)"} data={wauData} xField={"_id"} yField={"wau"} link={null}></GraphCard>
            <GraphCard title={"MAU (Monthly Active Users)"} data={mauData} xField={"_id"} yField={"mau"} link={null}></GraphCard>
          </Box>

          <Box flexDirection={"row"} display="flex" paddingTop="100px">
            <Card style={{ padding: "20px" }}>
              <div style={{ paddingBottom: "20px" }}>How many times users have opened the app this week:</div>

              {userFrequencyData.map((freq) => {
                return (
                  <Box flexDirection={"row"} display="flex">

                    <ListItem style={{ width: "50px", textAlign: "right" }} divider={true} key={freq._id + "1"}><b>{freq.freq}</b></ListItem>
                    <ListItem divider={true} key={freq._id}>{freq._id}</ListItem>
                  </Box>
                )
              })}
            </Card>

            <Card style={{ padding: "20px", marginLeft: "20px" }}>
              <div style={{ paddingBottom: "20px" }}>Current Streaks:</div>

              {outfitsScrolledOnFrequencyData.map((freq) => {
                return (
                  <Box flexDirection={"row"} display="flex">

                    <ListItem style={{ width: "50px", textAlign: "right" }} divider={true} key={freq._id + "1"}><b>{freq.freq}</b></ListItem>
                    <ListItem divider={true} key={freq._id}>{freq._id}</ListItem>
                  </Box>
                )
              })}
            </Card>

            <Card style={{ padding: "20px", marginLeft: "20px" }}>
              <div style={{ paddingBottom: "20px" }}>Total Meditation Time:</div>

              {outfitsScrolledOnFrequencyData.map((freq) => {
                return (
                  <Box flexDirection={"row"} display="flex">

                    <ListItem style={{ width: "50px", textAlign: "right" }} divider={true} key={freq._id + "1"}><b>{freq.freq}</b></ListItem>
                    <ListItem divider={true} key={freq._id}>{freq._id}</ListItem>
                  </Box>
                )
              })}
            </Card>


          </Box>
        </Box>
      </Box>

    </Box>
  );
}
