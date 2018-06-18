#include "LineSegmentation.hpp"
#include <string>

int main(int argc, char *argv[]) {
	
    string img_path = argv[1];
    string imgname=img_path;
    int pos=imgname.find_last_of("/");
    imgname=imgname.substr(pos+1);
    imgname=imgname.substr(0,imgname.find_last_of("."));
    cout<<img_path<<endl;
    cout<<imgname<<endl;
    LineSegmentation line_segmentation(img_path);
    vector<cv::Mat> lines = line_segmentation.segment();
    cout<<imgname<<endl;
    int idx = 0;
    for(auto m : lines) {
        imwrite(imgname+"_Line " + to_string(idx++) + ".jpg", m);
	
    }
    return 0;
}










