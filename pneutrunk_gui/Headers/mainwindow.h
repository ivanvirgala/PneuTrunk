#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QApplication>
#include <QMainWindow>

#include <memory>
#include <vector>
#include <eigen3/Eigen/Dense>
#include <cmath>

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>
#include <pneutrunk_msgs/msg/pneutrunk_joint_state.hpp>
#include "ros_module.h"
#include <QImage>
#include <QPixmap>

using namespace std::chrono_literals;
using std::placeholders::_1;

namespace Ui {
class MainWindow;
}


class MainWindow : public QMainWindow
{
    Q_OBJECT

    public:
        explicit MainWindow(QWidget *parent = nullptr);
        ~MainWindow();

        // QWidget * getParentWindow() override;

    private:
        Ui::MainWindow *ui;

        // ROS utils
        rosModule *ROS_thread;
        rclcpp::Node::SharedPtr _node;
        rclcpp::Publisher<pneutrunk_msgs::msg::PneutrunkJointState>::SharedPtr _joint_cmd_publisher;
 
        // Forward kinematics
        const uint _NUM_DOF = 7;
        Eigen::Matrix4d SegmentTransform(const double &roll, const double &pitch);
        void ForwardKinematics(const Eigen::VectorXd &q);
        std::vector<Eigen::Matrix4d> _T;
        std::vector<Eigen::Matrix4d> _Seg_T;
        double _r = 62.0;

    private slots:
        // void on_Button_Page_1_clicked();
        // void on_Button_Page_2_clicked();
        void on_Button();

        //slider_seg1_setRoll
        //slider_seg1_setPitch
        // CMD Slider for joints
        void on_Slider_seg1_setRoll_Released();
        void on_Slider_seg1_setPitch_Released();

        void on_Slider_seg2_setRoll_Released();
        void on_Slider_seg2_setPitch_Released();

        void on_Slider_seg3_setRoll_Released();
        void on_Slider_seg3_setPitch_Released();

        void on_Slider_seg4_setRoll_Released();
        void on_Slider_seg4_setPitch_Released();

        void on_Slider_seg5_setRoll_Released();
        void on_Slider_seg5_setPitch_Released();

        void on_Slider_seg6_setRoll_Released();
        void on_Slider_seg6_setPitch_Released();

        void on_Slider_seg7_setRoll_Released();
        


    public slots:
        void JointStateCallback();
        void GestureCameraCallback();
        void BallDetectionCameraCallback();

        // void ObjectDetectionCameraCallback();
};

QImage Mat2QImage(cv::Mat const& src);


#endif // MAINWINDOW_H