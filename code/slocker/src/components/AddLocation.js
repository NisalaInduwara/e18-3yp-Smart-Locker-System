import React, { useState } from "react";
import "../css/LockerDashboard.css";
import { db, storage } from "../config/config";
import { useHistory } from "react-router-dom";

export const AddLocation = ({userID}) => {
    const [name, setName] = useState("");
    const [count, setCount] = useState("");
    const [error, setError] = useState("");
    const history = useHistory();
    

    async function addlocation(e) {
        e.preventDefault();
        try {
            db.collection("Locations").add({
                    Name: name,
                    Count: count,
                    uid: userID,
                  }) .then(() => {
                    setName("");
                    setCount("");
                    setError("");
                    history.push("/LockerDashboard");
                  })
                  .catch((err) => setError(err.message));
            

        } catch {
      setError("Failed to Add Location");
    }
    }
            

    return (
        <div className='container'>
            <br/>
            <h2 className = "signintext">Add Location</h2>
            <form autoComplete="off" className='form-group' onSubmit={addlocation}>
            <label htmlFor="Location-name" className="formtext">Location Name</label>
                <input type="text" className='form-control' required
                    onChange={(e) => setName(e.target.value)} value={name} />
                <br />
                <label htmlFor="locker-count" className="formtext">Number of lockers</label>
                <input type="number" className='form-control' required
                    onChange={(e) => setCount(e.target.value)} value={count} />
                <br />
                <button type="submit" className='addbutton'>ADD</button>
                {error && <span className='error-msg'>{error}</span>}
            </form>
        </div>
    )
};