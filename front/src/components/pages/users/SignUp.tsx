import React, { useState, useContext } from "react"
import { useNavigate } from "react-router-dom"

import Card from "@mui/material/Card"
import CardContent from "@mui/material/CardContent"
import TextField from "@mui/material/TextField"

import { AuthUserContext } from "@src/components/models/user/AuthUserProvider"
import { AlertMessageContext } from "@src/components/ui/AlertMessage"
import { DefaultButton } from "@src/components/ui/Button"
import { PasswordForm } from "@src/components/ui/TextField"
import { signUp } from "@src/models/user/auth"
import { signedInCookiesSetter } from "@src/utils/client"
import { detectAxiosErrors } from "@src/utils/detectErrors"

import type { SignUpParams } from "@src/models/user/type"

const SignUp: React.FC = () => {
  const navigate = useNavigate()

  const { setIsSignedIn, setCurrentUser } = useContext(AuthUserContext)
  const [name, setName] = useState<string>("")
  const [email, setEmail] = useState<string>("")
  const [password, setPassword] = useState<string>("")
  const [passwordConfirmation, setPasswordConfirmation] = useState<string>("")
  const [showPassword, setShowPassword] = useState<boolean>(false)
  const { setAlertMessageOpen, setAlertMessage } = useContext(AlertMessageContext)

  const handleSubmit = async (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault()

    const Params: SignUpParams = {
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation
    }
    try {
      const res = await signUp(Params)

      if (res.status === 200) {
        signedInCookiesSetter(res)
        setIsSignedIn(true)
        setCurrentUser(res.data.data)

        navigate("/")
        console.log("Successfully SignUp")
      } else {
        setAlertMessageOpen(true)
      }
    } catch(e) {
      detectAxiosErrors(e, setAlertMessageOpen, setAlertMessage)
    }
  }

  return (
    <>
      <form noValidate autoComplete="off">
        <Card sx={{
          padding: (theme) => theme.spacing(2),
          maxWidth: 400
        }}>
          <CardContent>
            <TextField
              variant="outlined"
              fullWidth
              required
              label="Name"
              sx={{mb: 1}}
              value={name}
              onChange={event => setName(event.target.value)}
            />
            <TextField
              variant="outlined"
              fullWidth
              required
              label="Email"
              value={email}
              sx={{mb: 1}}
              onChange={event => setEmail(event.target.value)}
            />
            <PasswordForm
              id="outlined-adornment-password"
              label="Password"
              showPassword={showPassword}
              value={password}
              setPassword={setPassword}
              setShowPassword={setShowPassword}
            />
            <PasswordForm
              id="outlined-adornment-password-confirmation"
              label="PasswordConfirmation"
              showPassword={showPassword}
              value={passwordConfirmation}
              setPassword={setPasswordConfirmation}
              setShowPassword={setShowPassword}
            />
            <DefaultButton
              disabled={!name || !email || !password || !passwordConfirmation ? true : false}
              onClick={handleSubmit}
            >
              Submit
            </DefaultButton>
          </CardContent>
        </Card>
      </form>
    </>
  )
}

export default SignUp