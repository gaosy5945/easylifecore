package com.amarsoft.app.base.excel;

import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.model.SharedStringsTable;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class Excel2007Reader extends DefaultHandler {
	//�����ַ�����  
    private SharedStringsTable sst;  
    //��һ�ε�����  
    private String lastContents;  
    private boolean nextIsString;  
  
    private int sheetIndex = -1;  
    private List<String> rowlist = new ArrayList<String>();  
    //��ǰ��  
    private int curRow = 0;  
    //��ǰ��  
    private int curCol = 0;  
    //���ڱ�־  
    private boolean dateFlag;  
    //���ֱ�־  
    private boolean numberFlag;  
      
    private boolean isTElement;  
    
    private String lastName;
      
    private IRowReader rowReader;  
      
    public void setRowReader(IRowReader rowReader){  
        this.rowReader = rowReader;  
    }  
      
    /**ֻ����һ�����ӱ������sheetIdΪҪ������sheet��������1��ʼ��1-3 
     * @param filename 
     * @param sheetId 
     * @throws Exception 
     */  
    public void processOneSheet(String filename,int sheetId) throws Exception {  
        OPCPackage pkg = OPCPackage.open(filename);  
        XSSFReader r = new XSSFReader(pkg);  
        SharedStringsTable sst = r.getSharedStringsTable();  
        XMLReader parser = fetchSheetParser(sst);  
          
        // ���� rId# �� rSheet# ����sheet  
        InputStream sheet2 = r.getSheet("rId"+sheetId);  
        sheetIndex++;  
        InputSource sheetSource = new InputSource(sheet2);  
        parser.parse(sheetSource);  
        sheet2.close();  
    }  
  
    /** 
     * ���������������еĵ��ӱ�� 
     * @param filename 
     * @throws Exception 
     */  
    public void process(String filename) throws Exception {  
        OPCPackage pkg = OPCPackage.open(filename);  
        XSSFReader r = new XSSFReader(pkg);  
        SharedStringsTable sst = r.getSharedStringsTable();  
        XMLReader parser = fetchSheetParser(sst);  
        Iterator<InputStream> sheets = r.getSheetsData();  
        while (sheets.hasNext()) {  
            curRow = 0;  
            sheetIndex++;  
            lastName="";
            InputStream sheet = sheets.next();  
            InputSource sheetSource = new InputSource(sheet);  
            parser.parse(sheetSource);  
            sheet.close();  
        }  
    }  
  
    public XMLReader fetchSheetParser(SharedStringsTable sst)  
            throws SAXException {  
        XMLReader parser = XMLReaderFactory  
                .createXMLReader("com.sun.org.apache.xerces.internal.parsers.SAXParser");  
        this.sst = sst;  
        parser.setContentHandler(this);  
        return parser;  
    }  
  
    public void startElement(String uri, String localName, String name,  
            Attributes attributes) throws SAXException {  
    	dateFlag = false;
    	numberFlag = false;
        // c => ��Ԫ��  
        if ("c".equals(name)) {  
            // �����һ��Ԫ���� SST ����������nextIsString���Ϊtrue  
            String cellType = attributes.getValue("t");  
            if ("s".equals(cellType)) {  
                nextIsString = true;  
            } else {  
                nextIsString = false;  
            }  
            //���ڸ�ʽ  
            String cellDateType = attributes.getValue("s");  
            if ("1".equals(cellDateType)){  
                dateFlag = true;  
            } else {  
                dateFlag = false;  
            }  
            String cellNumberType = attributes.getValue("s");  
            if("2".equals(cellNumberType)){  
                numberFlag = true;  
            } else {  
                numberFlag = false;  
            }  
              
        }  
        //��Ԫ��Ϊtʱ  
        if("t".equals(name)){  
            isTElement = true;  
        } else {  
            isTElement = false;  
        }  
          
        // �ÿ�  
        lastContents = "";  
    }  
  
    public void endElement(String uri, String localName, String name)  
            throws SAXException {  
        
    	if ("c".equals(name) && "c".equals(lastName)){//��ʾ���ֶ�Ϊ��
    		 rowlist.add(curCol, "");  
             curCol++;  
             return;
    	}
    	
        // ����SST������ֵ�ĵ���Ԫ�������Ҫ�洢���ַ���  
        // ��ʱcharacters()�������ܻᱻ���ö��  
        if (nextIsString) {  
            try {  
                int idx = Integer.parseInt(lastContents);  
                lastContents = new XSSFRichTextString(sst.getEntryAt(idx))  
                        .toString();  
            } catch (Exception e) {  
  
            }  
        }   
        //tԪ��Ҳ�����ַ���  
        if(isTElement){  
            String value = lastContents.trim();  
            rowlist.add(curCol, value);  
            curCol++;  
            isTElement = false;  
            // v => ��Ԫ���ֵ�������Ԫ�����ַ�����v��ǩ��ֵΪ���ַ�����SST�е�����  
            // ����Ԫ�����ݼ���rowlist�У�����֮ǰ��ȥ���ַ���ǰ��Ŀհ׷�  
        } else if ("v".equals(name)) {  
            String value = lastContents.trim();  
            value = value.equals("")?" ":value;  
            //���ڸ�ʽ����  
            if(dateFlag){  
                 Date date = HSSFDateUtil.getJavaDate(Double.valueOf(value));  
                 SimpleDateFormat dateFormat = new SimpleDateFormat(  
                 "dd/MM/yyyy");  
                 value = dateFormat.format(date);  
            }  
            //�������ʹ���  
            if(numberFlag){  
                BigDecimal bd = new BigDecimal(value);  
                value = bd.setScale(3,BigDecimal.ROUND_UP).toString();  
            } 
            rowlist.add(curCol, value);  
            curCol++;  
        }else {  
            //�����ǩ����Ϊ row ����˵���ѵ���β������ optRows() ����  
            if (name.equals("row")) {  
            	if("c".equals(lastName)){
            		 rowlist.add(curCol, "");  
                     curCol++;  
            	}
                rowReader.getRows(sheetIndex,curRow,rowlist);  
                rowlist.clear();  
                curRow++;  
                curCol = 0;  
            }
        }  
        lastName = name;
    }  
  
    public void characters(char[] ch, int start, int length)  
            throws SAXException {  
        //�õ���Ԫ�����ݵ�ֵ  
        lastContents += new String(ch, start, length);  
    }  
}  
