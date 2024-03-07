import React, { useState, useContext } from "react"
import { useNavigate, Link as RouterLink} from "react-router-dom"
import Cookies from "js-cookie"

import { Typography } from "@mui/material"
import TextField from "@mui/material/TextField"
import Card from "@mui/material/Card"
import CardContent from "@mui/material/CardContent"
import CardHeader from "@mui/material/CardHeader"
import Button from "@mui/material/Button"
import Box from "@mui/material/Box"
import Link from '@mui/material/Link'

import { AuthUserContext } from "components/models/user/AuthUserProvider"
import AlertMessage from "components/ui/AlertMessage"
import { signIn } from "models/user/auth"
import { SignInParams } from "models/user/type"

const SignIn: React.FC = () => {
  const navigate = useNavigate()
  const { setIsSignedIn, setCurrentUser } = useContext(AuthUserContext)
  const [email, setEmail] = useState<string>("")
  const [password, setPassword] = useState<string>("")
  const [alertMessageOpen, setAlertMessageOpen] = useState<boolean>(false)

  const handleSubmit = async (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault()

    const params: SignInParams = {
      email: email,
      password: password
    }

    try{
      const res = await signIn(params)

      if (res.status === 200) {
        Cookies.set("_access_token", res.headers["access-token"])
        Cookies.set("_client", res.headers["client"])
        Cookies.set("_uid", res.headers["uid"])

        setIsSignedIn(true)
        setCurrentUser(res.data.data)

        navigate("/")
        console.log("Signed in successfully!")
      } else {
        setAlertMessageOpen(true)
      }
    } catch(err) {
      console.log(err)
      setAlertMessageOpen(true)
    }
  }

  return (
    <>
      <form noValidate autoComplete="off">
        <Card sx={{
          padding: (theme) => theme.spacing(2),
          maxWidth: 400
        }}>
          <CardHeader sx={{textAlign: "center"}} title="Sign In" />
          <CardContent>
            <TextField
              variant="outlined"
              required
              fullWidth
              label="Email"
              value={email}
              margin="dense"
              onChange={event=> setEmail(event.target.value)}
            />
            <TextField
              variant="outlined"
              required
              fullWidth
              label="Password"
              value={password}
              margin="dense"
              onChange={event=> setPassword(event.target.value)}
            />
            <Button
              variant="contained"
              size="large"
              color="primary"
              disabled={!email || !password ? true : false}
              sx={{
                marginTop: (theme) => theme.spacing(2),
                flexGrow: 1,
                textTransform: "none"
              }}
              onClick={handleSubmit}
            >
              Submit
            </Button>
            <Box textAlign="center" sx={{marginTop: "2rem"}}>
              <Typography variant="body2">
                Don't have an account? &nbsp;
                <Link component={RouterLink} to="/signup" sx={{textDecoration: "none"}}>Sign up</Link>
              </Typography>
            </Box>
          </CardContent>
        </Card>
      </form>
      <AlertMessage
        open={alertMessageOpen}
        setOpen={setAlertMessageOpen}
        severity="error"
        message="Invalid emai or password"
      ></AlertMessage>
    </>
  )
}

export default SignIn