package com.amarsoft.app.base.excel;

public class ExcelReaderUtil {

	//excel2003��չ��  
    public static final String EXCEL03_EXTENSION = ".xls";  
    //excel2007��չ��  
    public static final String EXCEL07_EXTENSION = ".xlsx";  
      
    /** 
     * ��ȡExcel�ļ���������03Ҳ������07�汾 
     * @param excel03 
     * @param excel07 
     * @param fileName 
     * @throws Exception  
     */  
    public static void readExcel(IRowReader reader,String fileName) throws Exception{  
        // ����excel2003�ļ�  
        if (fileName.endsWith(EXCEL03_EXTENSION)){  
            Excel2003Reader excel03 = new Excel2003Reader();  
            excel03.setRowReader(reader);  
            excel03.process(fileName);  
        // ����excel2007�ļ�  
        } else if (fileName.endsWith(EXCEL07_EXTENSION)){  
            Excel2007Reader excel07 = new Excel2007Reader();  
            excel07.setRowReader(reader);  
            excel07.process(fileName);  
        } else {  
            throw new  Exception("�ļ���ʽ����fileName����չ��ֻ����xls��xlsx��");  
        }  
    }  
}
