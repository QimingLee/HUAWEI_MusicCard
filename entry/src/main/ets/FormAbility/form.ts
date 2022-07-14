// @ts-nocheck
import commonEvent from '@ohos.commonEvent';
import formBindingData from '@ohos.application.formBindingData';
import formInfo from '@ohos.application.formInfo';

function publish(options) {
    commonEvent.publish("event.musicLab", options, (err) => {
        if (err) {
            console.error("commonEvent publish err because: " + JSON.stringify(err));
        } else {
            console.info("commonEvent publish success");
        }
    });
}

export default {
    onCreate(want, params) {
//        // Called to return a FormBindingData object.
//        let formData = {};
//        return formBindingData.createFormBindingData(formData);
        console.info("Form onCreate params: "+ JSON.stringify(params));
        let data;
        switch(params["ohos.extra.param.key.form_dimension"]) {
            case 1:
                data = {
                    "isMiniWidget": "true"
                };
                break;
            case 2:
                data ={
                    "isSmallWidget": "true"
                };
                break;
            case 3:
                data = {
                    "isLargeWidget": "true",
                };
                break;
            case 4:
                data = {
                    "isMidWidget": "true",
                };
                break;
            default:
                data ={
                    "isSmallWidget": "true",
                };
                break;
        }
        return formBindingData.createFormBindingData(data);
    },

    onCastToNormal(formId) {
        // Called when the form provider is notified that a temporary form is successfully
        // converted to a normal form.
    },

    onUpdate(formId) {
        // Called to notify the form provider to update a specified form.
    },

    onVisibilityChange(newStatus) {
        // Called when the form provider receives form events from the system.
    },

    onEvent(formId, message) {
        // Called when a specified message event defined by the form provider is triggered.
        console.info("Form onEvent:" , + JSON.stringify(formId), + JSON.stringify(message));
        let obj = JSON.parse(message);
        let msg = obj["mAction"];
        console.info("message is:" + JSON.stringify(msg));
        let commonEventPublishData = {
            parameters:{
                "message": msg,
                "formId": formId
            },
        };
        publish(commonEventPublishData);
    },

    onDestroy(formId) {
        // Called to notify the form provider that a specified form has been destroyed.
    },

    onAcquireFormState(want) {
        // Called to return a {@link FormState} object.
        return formInfo.FormState.READY;
    }
};