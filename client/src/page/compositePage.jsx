import React from "react";
import AdminModulesPage from "./admin/adminModulesPage";
import BrainstormPage from "./brainstorm/brainstormPage";
import AssignmentsPage from "./assignment/assignmentsPage";
import StaffVolunteerPage from "./volunteer/staffVolunteerPage";
import VolunteerSignUpPage from "./volunteer/volunteerSignUpPage";
import PrintRoomScheduleConfigPage from "./tool/printRoomScheduleConfig";
import SessionEnumerationConfigPage from "./tool/sessionEnumerationConfig";
import DevLoginPage from "./login/login";

/**
 * Implementing this as a sort-of pauper's version of a Router. We're starting with an
 * assumption (that might, or might not be true) that when the page loads, the React
 * app will do one thing (based on the URL), and that "leaving" the page will result
 * in a completely different instance of the app doing a different thing. Even if all
 * the code is the same, different URLs invoke different abilities.
 *
 * We can revisit this pattern later.
 */
class CompositePage extends React.Component {

    render() {
        let url = new URL(window.location.href);
        if (url.pathname === '/StaffVolunteerPage.php') {
            return (<StaffVolunteerPage />);
        } else if (url.pathname === '/AdminModules.php') {
            return (<AdminModulesPage />);
        } else if (url.pathname === '/volunteering.php') {
            return (<VolunteerSignUpPage />);
        } else if (url.pathname === '/brainstorm.php') {
            return (<BrainstormPage />);
        } else if (url.pathname === '/assignParticipants.php') {
            return (<AssignmentsPage />);
        } else if (url.pathname === '/assignSessionNumberConfig.php') {
            return (<SessionEnumerationConfigPage />);
        } else if (url.pathname === '/printRoomScheduleConfig.php') {
            return (<PrintRoomScheduleConfigPage />);
        } else if (url.pathname === "/devLogin.php") {
            return <DevLoginPage />;
        } else {
            return (<h4>Unknown Page</h4>);
        }
    }
}

export default CompositePage;
