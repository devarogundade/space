import {
    getStorage,
    ref,
    uploadBytesResumable,
    getDownloadURL
} from "firebase/storage";

import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
    apiKey: "AIzaSyCCNlTEBSPgqoe5J1TsFljKfkJvxDwt7dw",
    authDomain: "fleet-a6979.firebaseapp.com",
    projectId: "fleet-a6979",
    storageBucket: "fleet-a6979.appspot.com",
    messagingSenderId: "1000201366682",
    appId: "1:1000201366682:web:555a8af7080ee6638d0323",
    measurementId: "G-MLM9X7SRV1"
};

const StorageAPI = {
    toBase64: function (file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => resolve(reader.result);
            reader.onerror = error => reject(error);
        })
    },
    upload(blob, name) {
        const firebaseApp = initializeApp(firebaseConfig);
        getAnalytics(firebaseApp);

        return new Promise((resolve, reject) => {
            const storage = getStorage();
            const storageRef = ref(storage, `images/${name}`);
            const uploadTask = uploadBytesResumable(storageRef, blob);
            uploadTask.on('state_changed',
                (snapshot) => {
                    const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                    console.log('Upload is ' + progress + '% done');
                },
                (error) => {
                    console.log(error);
                    console.error('firebase', error);
                    reject(error);
                },
                async () => {
                    const url = await getDownloadURL(uploadTask.snapshot.ref)
                    resolve(url);
                }
            );
        });
    }
}

export default StorageAPI