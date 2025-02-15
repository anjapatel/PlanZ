<?php
//	Copyright (c) 2011-2021 Peter Olszowka. All rights reserved. See copyright document for more details.
global $header_section;
$header_section = HEADER_PARTICIPANT;

function participant_header($title, $noUserRequired = false, $loginPageStatus = 'Normal', $bootstrap4 = false) {
    // $noUserRequired is true if user not required to be logged in to access this page
    // $loginPageStatus is "Login", "Logout", "Normal", "No_Permission", "Password_Reset"
    //      login page should be "Login"
    //          don't show menu; show login form in header
    //      logout page should be "Logout"
    //          don't show menu; show logout confirmation in header
    //      logged in user who reached page for which he does not have permission is "No_Permission"
    //          show menu; don't show page; show "No permission" where?
    //      pages for user to reset password are "Password_Reset"
    //          don't show menu; show header without welcome; show page
    //      override page to gather user data retention consent is "Consent"
    //          don't show menu; show dataConsent page; show normal header (with welcome)
    //      all other pages should be "Normal"
    //          show menu; show page; show normal header (with welcome)
    global $headerErrorMessage;
    $isLoggedIn = isLoggedIn();
    if ($isLoggedIn && REQUIRE_CONSENT && (empty($_SESSION['data_consent']) || $_SESSION['data_consent'] !== 1)) {
        $title = "Data Retention Consent";
        $loginPageStatus = 'Consent';
        $bootstrap4 = true;
    }
    html_header($title, $bootstrap4);
    if ($bootstrap4) { ?>
<body class="bs4">
<?php } else { ?>
<body>
<?php } ?>
    <div class="container-fluid">
<?php
    commonHeader('Participant', $isLoggedIn, $noUserRequired, $loginPageStatus, $headerErrorMessage, $bootstrap4);
    // below: authenticated and authorized to see a menu
    if ($isLoggedIn && $loginPageStatus != 'Login' && $loginPageStatus != 'Consent' &&
        (may_I("Participant") || may_I("Staff"))) {
    // check if survey is defined to set Survey Menu item in paramArray
        if (!isset($_SESSION['survey_exists'])) {
            //$_SESSION['survey_exists'] = survey_programmed();
            $_SESSION['survey_exists'] = USING_SURVEYS === TRUE ? survey_programmed() : FALSE;
        }
        if ($bootstrap4) {
            $paramArray = array();
            $paramArray["title"] = $title;
            $paramArray["basepath"] = BASE_PATH;
            $paramArray["my_suggestions"] = may_I('my_suggestions_write') ? true : false;
            $paramArray["SessionFeedback"] = may_I('SessionFeedback') ? true : false;
            $paramArray["SessionInterests"] = may_I('my_panel_interests') ? true : false;
            $paramArray["survey"] = array_key_exists('survey_exists', $_SESSION) ? $_SESSION['survey_exists'] : false;
            $paramArray["PARTICIPANT_PHOTOS"] = PARTICIPANT_PHOTOS === TRUE ? 1 : 0;
            RenderXSLT('ParticipantMenu_BS4.xsl', $paramArray, GeneratePermissionSetXML());
        } else {
?>
        <nav id="participantNav" class="navbar navbar-inverse">
            <div class="navbar-inner">
                <div class="container" style="width: auto;">
                    <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </a>
                    <a class="brand" href="<?php if (isset($_SERVER['PATH_INFO'])) echo $_SERVER['PATH_INFO'] ?>"><?php echo $title ?></a>
                    <div class="nav-collapse">
                        <ul class="nav">
                            <li><a href="welcome.php">Overview</a></li>
                            <li><a href="my_contact.php">Profile</a></li>
                            <li><a href="my_details.php">Personal Details</a></li>
                            <?php makeMenuItem("Photo", PARTICIPANT_PHOTOS === TRUE, "my_photo.php", false); ?>
                            <?php if ($_SESSION['survey_exists']) { ?>
                                <li><a href="PartSurvey.php">Survey</a></li>
                            <?php } ?>
                            <?php makeMenuItem("Availability", may_I('my_availability'),"my_sched_constr.php",false); ?>
                            <?php makeMenuItem("General Interests",1,"my_interests.php",false); ?>
                            <?php makeMenuItem("My Suggestions", may_I('my_suggestions_write'),"my_suggestions.php",false); ?>
                            <?php makeMenuItem("Search Sessions", may_I('search_panels'),"PartSearchSessions.php", false); ?>
                            <?php makeMenuItem("Session Interests", may_I('my_panel_interests'),"PartPanelInterests.php",false); ?>
                            <?php makeMenuItem("My Schedule", may_I('my_schedule'),"MySchedule.php",false); ?>
                            <?php makeMenuItem("Volunteering", may_I('Volunteering'),"volunteering.php",false); ?>
                            <li class="divider-vertical"></li>
                            <?php makeMenuItem("Suggest a Session", may_I('BrainstormSubmit'),"./brainstorm.php", false); ?>
                            <li class="divider-vertical"></li>
                        </ul>
                            <?php if (may_I('Staff')) {
                                echo '<ul class="nav pull-right"><li class="divider-vertical"></li><li><a id="StaffView" href="StaffPage.php">Staff View</a></li></ul>';
                            }?>
                    </div>
                </div>
            </div>
        </nav>
<?php       }
    } else { // couldn't show menu
        if ($loginPageStatus === 'Consent') {
            require('dataConsent.php');
            exit();
        } elseif (!$noUserRequired) { // not authenticated and authorized to see a menu
            participant_footer();
            exit();
        }
    }
}
?>
