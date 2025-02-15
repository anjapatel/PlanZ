<?xml version='1.0' encoding="UTF-8"?>
<!--
    Created by Peter Olszowka on 2020-04-12;
    Copyright (c) 2020-2021 Peter Olszowka. All rights reserved. See copyright document for more details.
-->
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="title" select="''" />
  <!-- Page title -->
  <xsl:param name="basepath" select="'/'"/>
  <xsl:param name="reportMenuList" select="''"/>
  <xsl:param name="PARTICIPANT_PHOTOS" select="'0'"/>
  <xsl:param name="emailAvailable" select="'0'"/>
  <!-- Set of <li> elements; contents of ReportMenuInclude.php -->
  <xsl:variable name="ConfigureReports" select="/doc/query[@queryname='permission_set']/row[@permatomtag='ConfigureReports']"/>
  <xsl:variable name="AdminPhases" select="/doc/query[@queryname='permission_set']/row[@permatomtag='AdminPhases']"/>
  <xsl:variable name="AdminModules" select="/doc/query[@queryname='permission_set']/row[@permatomtag='AdminModules']"/>
  <xsl:variable name="Administrator" select="/doc/query[@queryname='permission_set']/row[@permatomtag='Administrator']"/>
  <xsl:variable name="ExportSchedule" select="/doc/query[@queryname='permission_set']/row[@permatomtag='ExportSchedule']"/>
  <xsl:variable name="ShowVolunteer" select="/doc/query[@queryname='permission_set']/row[@permatomtag='Volunteering Set-up']"/>
  <xsl:variable name="EditAnyTable" select="/doc/query[@queryname='permission_set']/row[@permatomtag='ce_All' or
        @permatomtag='ce_AgeRanges' or @permatomtag='ce_BioEditStatuses' or @permatomtag='ce_Credentials' or @permatomtag='ce_Divisions' or
        @permatomtag='ce_EmailCC' or @permatomtag='ce_EmailFrom' or @permatomtag='ce_EmailTo' or @permatomtag='ce_Features' or
        @permatomtag='ce_Interests' or @permatomtag='ce_KidsCategories' or @permatomtag='ce_LanguageStatuses' or
        @permatomtag='ce_Locations' or @permatomtag='ce_PhotoDenialReasons' or @permatomtag='ce_Pronouns' or @permatomtag='ce_PubStatuses' or
        @permatomtag='ce_RegTypes' or @permatomtag='ce_Roles' or @permatomtag='ce_RoomColors' or @permatomtag='ce_Rooms' or @permatomtag='ce_RoomSets' or
        @permatomtag='ce_RoomHasSet' or @permatomtag='ce_Services' or @permatomtag='ce_ServiceTypes' or @permatomtag='ce_SessionStatuses' or
        @permatomtag='ce_Tags' or @permatomtag='ce_Times' or @permatomtag='ce_Tracks' or @permatomtag='ce_Types']"/>
  <xsl:variable name="AutoScheduler" select="/doc/query[@queryname='permission_set']/row[@permatomtag='AutoScheduler']"/>
  <xsl:template match="/">
    <nav id="staffNav" class="navbar navbar-inverse">
      <div class="navbar-inner">
        <div class="container" style="width: auto;">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"/>
            <span class="icon-bar"/>
            <span class="icon-bar"/>
          </a>
          <span class="brand inactive">
            <xsl:value-of select="$title"/>
          </span>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="dropdown">
                <a href="#sessions" class="dropdown-toggle" data-toggle="dropdown">
                  Sessions
                  <b class="caret"/>
                </a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="{$basepath}StaffSearchSessions.php">Search Sessions</a>
                  </li>
                  <li>
                    <a href="{$basepath}CreateSession.php">Create New Session</a>
                  </li>
                  <li>
                    <a href="{$basepath}ViewSessionCountReport.php">View Session Counts</a>
                  </li>
                  <li>
                    <a href="{$basepath}ViewAllSessions.php">View All Sessions</a>
                  </li>
                  <li>
                    <a href="{$basepath}ViewPrecis.php?showlinks=0">View Precis</a>
                  </li>
                  <li>
                    <a href="{$basepath}ViewPrecis.php?showlinks=1">View Precis with Links</a>
                  </li>
                  <li>
                    <a href="{$basepath}StaffSearchPreviousSessions.php">Import Sessions</a>
                  </li>
                  <li>
                    <a href="{$basepath}SessionHistory.php">Session History</a>
                  </li>
                </ul>
              </li>
              <li class="dropdown">
                <a href="#participants" class="dropdown-toggle" data-toggle="dropdown">
                  Participants
                  <b class="caret"/>
                </a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="{$basepath}AdminParticipants.php">Administer</a>
                  </li>
                  <xsl:if test="$PARTICIPANT_PHOTOS = '1'">
                    <li>
                      <a href="{$basepath}AdminPhotos.php">Photos</a>
                    </li>
                  </xsl:if>
                  <li>
                    <a href="{$basepath}InviteParticipants.php">Invite to a Session</a>
                  </li>
                  <xsl:if test="$emailAvailable = '1' and /doc/query[@queryname='permission_set']/row[@permatomtag='SendEmail']">
                    <li>
                      <a href="{$basepath}StaffSendEmailCompose.php">Send email</a>
                    </li>
                  </xsl:if>
                  <xsl:if test="/doc/query[@queryname='permission_set']/row[@permatomtag='CreateUser']">
                    <li>
                      <a href="{$basepath}AddUser.php">Create User</a>
                    </li>
                  </xsl:if>
                </ul>
              </li>
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  Reports
                  <b class="caret"/>
                </a>
                <ul class="dropdown-menu">
                  <xsl:choose>
                    <xsl:when test="$reportMenuList != ''">
                      <xsl:value-of select="$reportMenuList" disable-output-escaping="yes"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <li>
                        <div class='menu-error-entry'>Report menus not built!</div>
                      </li>
                    </xsl:otherwise>
                  </xsl:choose>
                  <li class='divider'/>
                  <li>
                    <a href='/staffReportsInCategory.php'>All Reports</a>
                  </li>
                </ul>
              </li>
              <li class="dropdown">
                <a href="#scheduling" class="dropdown-toggle" data-toggle="dropdown">
                  Scheduling
                  <b class="caret"/>
                </a>
                <ul class="dropdown-menu">
                  <xsl:if test="$AutoScheduler">
                    <li>
                      <a href="{$basepath}Autoscheduler.php">Auto-Scheduler</a>
                    </li>
                  </xsl:if>
                  <li>
                    <a href="{$basepath}MaintainRoomSched.php">Maintain Room Schedule</a>
                  </li>
                  <li>
                    <a href="{$basepath}StaffMaintainSchedule.php">Grid Scheduler</a>
                  </li>
                  <li>
                    <a href="{$basepath}CurrentSchedule.php">Current Schedule</a>
                  </li>
                  <xsl:if test="$ShowVolunteer">
                    <li>
                      <a class="dropdown-item" href="{$basepath}StaffVolunteerPage.php">Create Volunteer Schedule</a>
                    </li>
                  </xsl:if>

                </ul>
              </li>
              <li class="divider-vertical"/>
              <li>
                <a href="{$basepath}StaffPage.php">Overview</a>
              </li>
              <li>
                  <a href="{$basepath}Tools.php">Tools</a>
              </li>
              <li class="divider-vertical"/>
              <li>
                <form method="post" action="ShowSessions.php" class="navbar-search pull-left">
                  <input type="text" name="searchtitle" class="search-query" placeholder="Search for sessions by title"/>
                  <input type="hidden" value="ANY" name="track"/>
                  <input type="hidden" value="ANY" name="status"/>
                  <input type="hidden" value="ANY" name="type"/>
                  <input type="hidden" value="" name="sessionid"/>
                  <input type="hidden" value="ANY" name="divisionid"/>
                </form>
              </li>
              <xsl:variable name="AdminMenu" select="$AdminPhases or $ConfigureReports or $Administrator or $EditAnyTable or $ExportSchedule" />
              <xsl:if test="$AdminMenu">
                <li class="dropdown">
                  <a href="#admin" class="dropdown-toggle" data-toggle="dropdown">
                    Admin
                    <b class="caret"/>
                  </a>
                  <ul class="dropdown-menu">
                    <xsl:if test="$AdminPhases">
                      <li>
                        <a href="{$basepath}AdminPhases.php">Administer Phases</a>
                      </li>
                    </xsl:if>
                    <xsl:if test="$ConfigureReports">
                      <li>
                        <a href="{$basepath}BuildReportMenus.php">Build Report Menus</a>
                      </li>
                    </xsl:if>
                    <xsl:if test="$Administrator">
                      <li>
                        <a href="{$basepath}ConfigurationAdmin.php">Edit Configuration Settings</a>
                      </li>
                      <li>
                        <a href="{$basepath}EditCustomText.php">Edit Custom Text</a>
                      </li>
                      <li>
                        <a href="{$basepath}EditSurvey.php">Edit Survey</a>
                      </li>
                    </xsl:if>
                    <xsl:if test="$EditAnyTable">
                        <li>
                          <a href="{$basepath}ConfigTableEditor.php">Edit Configuration Tables</a>
                        </li>
                    </xsl:if>
                    <xsl:if test="$ExportSchedule">
                      <li>
                        <a href="{$basepath}StaffCreateKonOpas.php">Update KonOpas and ConClar</a>
                      </li>
                    </xsl:if>
                    <xsl:if test="$AdminModules">
                      <li>
                        <a href="{$basepath}AdminModules.php">Administer Modules</a>
                      </li>
                    </xsl:if>
                  </ul>
                </li>
              </xsl:if>
            </ul>
            <ul class="nav pull-right">
              <li class="divider-vertical"/>
              <li>
                <a id="ParticipantView" href="{$basepath}welcome.php">Participant View</a>
              </li>
            </ul>
          </div>
          <!--/.nav-collapse -->
        </div>
      </div>
    </nav>
  </xsl:template>
</xsl:stylesheet>
