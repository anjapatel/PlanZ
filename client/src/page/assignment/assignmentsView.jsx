import React from "react";
import { useEffect } from "react";
import Card from "react-bootstrap/Card";
import Spinner from "react-bootstrap/Spinner";
import { connect } from "react-redux";
import SimpleAlert from "../../common/simpleAlert";
import { fetchSessionAssignments } from "../../state/assignmentsFunctions";

const AssignmentsView = (props) => {

    useEffect(() => fetchSessionAssignments(props.sessionId), []);

    if (props.loading) {
        return (
            <div className="text-center">
                <Spinner animation="border" />
            </div>
        );
    } else {

        let sessionBlock = (props.session) ? (<div className="mb-3">
                <h3>{props.session.title}</h3>
                <div>{props.session.programGuideDescription}</div>
                <div><i>Notes:</i> {props.session.notesForProgramStaff || "None"}</div>
            </div>) : undefined;

        let assignmentBlock = (props.assignments) 
            ? (<div><h4>Currently Assigned</h4><div className="row row-cols-1 row-cols-md-4 mb-3">
                {props.assignments.map(a => { return (<div className="col" key={a.badgeId}><Card>
                        <Card.Body>
                            <Card.Title>{a.name} <span className="text-muted small">({a.badgeId})</span></Card.Title>
                            <Card.Text>
                            Some quick example text to build on the card title and make up the
                            bulk of the card's content.
                            </Card.Text>
                        </Card.Body>
                    </Card></div>); })}
                </div></div>) 
            : undefined;
        return (<div>
            <SimpleAlert message={props.message} />
            {sessionBlock}
            {assignmentBlock}
            </div>)
    }
}

function mapStateToProps(state) {
    return { 
        session: state.assignments.data.session ? state.assignments.data.session : undefined,
        assignments: state.assignments.data.assignments ? state.assignments.data.assignments : undefined,
        loading: state.assignments.data.loading,
        message: state.assignments.data.message
    };
}

export default connect(mapStateToProps)(AssignmentsView);