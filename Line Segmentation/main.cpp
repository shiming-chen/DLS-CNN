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



/*
void main(int argc, char *argv[])
{
    cout << argv[1] << endl;
    string img_path = argv[1];
    IplImage *src;
    IplImage *dst;
    WIN32_FIND_DATA p; 
    int idx = 0;
    string imgname;
    char filename[1];
    HANDLE h=FindFirstFile("%s\\*.jpg",imgpath,&p); 


    string src_route_head=img_path+"\\"; 
   
    string SourceRoute=src_route_head+p.cFileName; 
    LineSegmentation line_segmentation("%s\\%s.jpg",imgpath,p.cFileName);
    vector<cv::Mat> lines = line_segmentation.segment();
    imgname=p.cFileName;
    cout << imgname <<endl;
    imgname=imgname.substr(0,str.find_last_of("."));
    cout << imgname <<endl;
    
    for(auto m : lines) {
        //sprintf(filename, "%s\\%s_Line_%d.jpg","/home/shimingchen/project/Image2Lines/img",imgname,idx);
        imwrite(imgname+"_Line " + to_string(idx++) + ".jpg", m);
	
	
    }
    
    

    

    while(FindNextFile(h,&p)) 
    { 
       int idxx;
       HANDLE h=FindFirstFile("%s\\*.jpg",imgpath,&p); 


       string src_route_head=img_path+"\\"; 
   
       string SourceRoute=src_route_head+p.cFileName; 
       LineSegmentation line_segmentation("%s\\%s.jpg",imgpath,p.cFileName);
       vector<cv::Mat> lines = line_segmentation.segment();
       imgname=p.cFileName;
       cout << imgname <<endl;
       imgname=imgname.substr(0,str.find_last_of("."));
       cout << imgname <<endl;
    
       for(auto m : lines) {
           //sprintf(filename, "%s\\%s_Line_%d.jpg","/home/shimingchen/project/Image2Lines/img",imgname,idxx);
           imwrite(imgname+"_Line " + to_string(idxx++) + ".jpg", m);
	
    }
    }
    return 0;
}
*/

//2018/3/30

/*
int main(int argc, char *argv[]) {
    cout << argv[1] << endl;
    string file_path = argv[1];
    string ImgName;
    string img_path;
    string Savefile;
    ifstream fin(file_path);
    if (getline(fin, ImgName)){
        cout << "Handle_" << ImgName << endl;
        img_path = "\\home\\shimingchen\\project\\Image2Lines\\HistoricalWI_Train_binary_origin_white\\"+ ImgName ;
	ImgName=ImgName.substr(0,ImgName.find_last_of("."));
	cout<<img_path<<endl;
	cout<<"1"<<ImgName<<endl;
        LineSegmentation line_segmentation(img_path);
	cout<<img_path<<endl;
	cout<<"2"<<ImgName<<endl;
        vector<cv::Mat> lines = line_segmentation.segment();
	cout<<"3"<<ImgName<<endl;
        int idx = 0;
   	for(auto m : lines) {
		Savefile="\\home\\shimingchen\\project\\Image2Lines\\HistoricalWI_Train_binary_origin_white_Line\\"+ImgName+"Line"+ to_string(idx++) + ".jpg";
        	imwrite(Savefile, m);
	}
	
    }
    return 0;
}

*/







