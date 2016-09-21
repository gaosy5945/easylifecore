package com.amarsoft.ars.file;

import com.amarsoft.are.ARE;
import com.amarsoft.ars.utils.StringUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Writer;
import java.util.Enumeration;
import java.util.Properties;

//jar包里类线程不安全，山寨一个出来
public class FileUtils
{
  private String sRowResult = "";
  private BufferedReader bufferedreader;
  private String tempStr = "";
  private static String sysSeparator =File.separator;
  private String dataFileName;
  private String absolutePath;
  private String absoluteFile;
 
  public FileUtils()
  {
    Properties prop = new Properties(System.getProperties());
  }

  public FileUtils(String path, Properties mapCondition) throws Exception
  {
    absolutePath = getAbsolutePath(path, mapCondition);
    dataFileName = getFileName(mapCondition, ".dat", false);
    absoluteFile = absolutePath + sysSeparator + dataFileName;
  }

  public String getAbsoluteFilePath() {
    return absolutePath + sysSeparator;
  }

  public String getAbsoluteFileName() {
    return absoluteFile;
  }

  public String getSysSeparator() {
    return sysSeparator;
  }

  public String getDataFileName() {
    return dataFileName;
  }

  public String loadDataFromFile() throws Exception {
    bufferedreader = new BufferedReader(new InputStreamReader(new FileInputStream(absoluteFile), ARE.getProperty("CharSet","GBK")));
    StringBuffer sResultJS = new StringBuffer();
    try {
      for (; fetch(); sResultJS.append(sRowResult).append("\n"));
    }
    catch (Exception e) {
      throw new Exception("读取数据文件出现异常。");
    }
    bufferedreader.close();
    return sResultJS.toString();
  }

  public void loadDataFromFile(Writer wt) throws Exception {
    try {
      bufferedreader = new BufferedReader(new InputStreamReader(new FileInputStream(absoluteFile), ARE.getProperty("CharSet","GBK")));
      for (; fetch(); wt.write("\n"))
        wt.write(sRowResult);
    }
    catch (Exception e)
    {
      throw new Exception(
        "读取数据文件出现异常。" + e);
    } finally {
      bufferedreader.close();
    }
  }

  public void loadDataFromFile(Writer wt, File file) throws Exception {
    try {
      bufferedreader = new BufferedReader(new InputStreamReader(new FileInputStream(file), ARE.getProperty("CharSet","GBK")));
      for (; fetch(); wt.write("\n"))
        wt.write(sRowResult);
    }
    catch (Exception e)
    {
      throw new Exception(
        "读取数据文件出现异常。" + e);
    } finally {
      bufferedreader.close();
    }
  }

  public boolean ifFileExisted() {
    File file = new File(absoluteFile);
    boolean fileExists = false;
    if (file.exists()) {
      fileExists = true;
    }
    file = null;
    return fileExists;
  }

  public boolean fetch() {
    try {
      sRowResult = bufferedreader.readLine();
      if (sRowResult == null) {
        return false;
      }
      return (sRowResult.trim().length() != 0);
    } catch (Exception e) {
      System.out.println("无法读取数据：" + 
        e.toString()); }
    return false;
  }

  public void checkDirStructure()
    throws Exception
  {
    String[] sPathArray = StringUtils.toStringArray(absolutePath, sysSeparator);
    tempStr = sPathArray[0];
    for (int i = 1; i < sPathArray.length; ++i)
    {
      tempStr = tempStr + sysSeparator + sPathArray[i];
      if (i < sPathArray.length - 4) {
        continue;
      }
      File file = new File(tempStr);
      if ((file.exists()) && (file.isDirectory()))
        file = null;
      else
        try
        {
          file.mkdir();
        } catch (Exception e) {
          throw new Exception("建立数据文件目录(" + 
            tempStr + ")出现异常。" + e);
        } finally {
          file = null;
        }
    }
  }

  private String getAbsolutePath(String basePath, Properties mapCondition) throws Exception {
    if (basePath.length() == 0) {
      throw new Exception(
        "设置的数据文件存储路径有误！[" + 
        basePath + "]");
    }
    StringBuffer sAbsolutePath = new StringBuffer(basePath);
    String sDirMonth = StringUtils.replace(mapCondition.getProperty("InputDate"), "/", "");
    String sDirOrg = mapCondition.getProperty("OrgID");
    if ((!(basePath.substring(basePath.length() - 1, basePath.length()).equals("/"))) && 
      (!(basePath.substring(basePath.length() - 1, basePath.length()).equals("\\")))) {
      sAbsolutePath.append(sysSeparator);
    }
    sAbsolutePath.append("ResultsJS").append(sysSeparator).append(sDirMonth).append(sysSeparator).append(sDirOrg);
    return sAbsolutePath.toString();
  }

  public String getFileName(Properties mapCondition, String fileType, boolean isFull) {
    StringBuffer s = new StringBuffer(100);
    Enumeration params = mapCondition.propertyNames();

    while (params.hasMoreElements())
    {
      tempStr = (String)params.nextElement();
      if ((isFull) || ((!(tempStr.equals("OrgID"))) && (!(tempStr.equals("InputDate")))))
      s.append(",").append(mapCondition.getProperty(tempStr));
    }

    s.append(fileType);
    String sFileName = StringUtils.replace(s.toString(), "/", "");

    return sFileName;
  }

  public String getFileName(Properties mapCondition, String fileType) {
    return getFileName(mapCondition, fileType, true);
  }

  public String convertFilePath(String basePath, String appendDir) {
    String[] dirParams = StringUtils.toStringArray(appendDir, "/");
    StringBuffer convertPath = new StringBuffer(basePath);
    if (basePath.substring(basePath.length() - 1, basePath.length()).equals(sysSeparator)) {
      convertPath.deleteCharAt(basePath.length() - 1);
    }
    for (int i = 0; i < dirParams.length; ++i) {
      if ((dirParams[i] != null) && (dirParams[i].length() != 0)) {
        convertPath.append(sysSeparator).append(dirParams[i]);
      }
    }

    return convertPath.toString();
  }
}

