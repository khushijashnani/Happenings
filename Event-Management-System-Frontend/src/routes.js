import DashboardPage from "pages/DashboardPage";
import ManageEvents from "pages/ManageEvents";
import UserProfilePage from "pages/UserProfilePage";
/*!

=========================================================
* Black Dashboard React v1.1.0
=========================================================

* Product Page: https://www.creative-tim.com/product/black-dashboard-react
* Copyright 2020 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://github.com/creativetimofficial/black-dashboard-react/blob/master/LICENSE.md)

* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/
import Dashboard from "views/Dashboard.js";
import Icons from "views/Icons.js";
import Map from "views/Map.js";
import Notifications from "views/Notifications.js";
import Rtl from "views/Rtl.js";
import TableList from "views/TableList.js";
import Typography from "views/Typography.js";
import UserProfile from "views/UserProfile.js";

var routes = [
  {
    path: "/dashboard",
    name: "Dashboard",
    rtlName: "لوحة القيادة",
    icon: "tim-icons icon-chart-pie-36",
    component: DashboardPage,
    layout: "/admin"
  },

  {
    path: "/userprofile",
    name: "User Profile",
    rtlName: "ملف تعريفي للمستخدم",
    icon: "tim-icons icon-single-02",
    component: UserProfilePage,
    layout: "/admin"
  },
  {
    path: "/events",
    name: "Manage Events",
    rtlName: "ملف تعريفي للمستخدم",
    icon: "tim-icons icon-bullet-list-67",
    component: ManageEvents,
    layout: "/admin"
  },


];
export default routes;
