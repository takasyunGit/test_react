import React, { useState, useContext } from "react"
import { useNavigate } from "react-router-dom"

import Card from "@mui/material/Card"
import CardContent from "@mui/material/CardContent"
import CardHeader from "@mui/material/CardHeader"

import { AlertMessageContext } from "@src/components/ui/AlertMessage"
import { DefaultButton } from "@src/components/ui/Button"
import { OptionalTextField, AmountForm, SelectForm } from "@src/components/ui/TextField"
import { createUserOffer } from "@src/models/user_offer/request"
import { signedInCookiesSetter } from "@src/utils/client"
import { PREFECTURES_NAME_LIST, USER_OFFER_REQUEST_TYPE_LIST } from "@src/utils/constants"
import { detectAxiosErrors } from "@src/utils/detectErrors"

import type { CreateUserOfferParams } from "@src/models/user_offer/type"
import type { PrefectureCode, UserOfferRequestTypeCode } from "@src/utils/type"

const CreateUserOffer: React.FC = () => {
  const [prefecture, setPrefecture] = useState<PrefectureCode | ''>('')
  const [address, setAddress] = useState<string>('')
  const [budget, setBudget] = useState<string>('')
  const [remark, setRemark] = useState<string>('')
  const [requestType, setRequestType] = useState<UserOfferRequestTypeCode | ''>('')
  const { setAlertMessageOpen, setAlertMessage } = useContext(AlertMessageContext)
  const navigate = useNavigate()

  const handleSubmit = async (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault()

    const params: CreateUserOfferParams = {
      prefecture: prefecture as PrefectureCode,
      address: address,
      budget: +budget.replace(/,/g, ''),
      remark: remark,
      requestType: requestType as UserOfferRequestTypeCode
    }

    try{
      const res = await createUserOffer(params)
      if (!res) { return navigate("/signin") }
      signedInCookiesSetter(res)

      if (res && res.status === 200) {
        navigate("/")
      } else {
        setAlertMessage("An unexpected error has occurred")
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
          <CardHeader sx={{textAlign: "center"}} title="Create user offer" />
          <CardContent>
            <SelectForm
              label="Prefecture"
              width="35%"
              value={prefecture as PrefectureCode}
              list={PREFECTURES_NAME_LIST}
              onChange={e=> setPrefecture(e as PrefectureCode)}
            />
            <OptionalTextField
              label="Address"
              value={address}
              onChange={e=> setAddress(e)}
            />
            <AmountForm
              label="Budget"
              value={budget}
              required={true}
              onChange={e=> setBudget(e)}
            />
            <OptionalTextField
              label="Remark"
              minRows="3"
              value={remark}
              onChange={e=> setRemark(e)}
            />
            <div>
              <SelectForm
                label="Request type"
                width="40%"
                value={requestType as UserOfferRequestTypeCode}
                list={USER_OFFER_REQUEST_TYPE_LIST}
                onChange={e=> setRequestType(e as UserOfferRequestTypeCode)}
              />
            </div>
            <DefaultButton
              disabled={!prefecture || !budget  || !requestType ? true : false}
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

export default CreateUserOffer