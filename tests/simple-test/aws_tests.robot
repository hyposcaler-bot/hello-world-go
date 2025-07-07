*** Settings ***
Documentation     AWS Credentials and S3 Operations Test Suite
Library           OperatingSystem
Library           Process
Library           Collections

*** Variables ***
${BUCKET_NAME}    clab-integration
${FILE_KEY}       srl02-s3.clab.yml
${LOCAL_FILE}     srl02-s3.clab.yml

*** Test Cases ***
Check AWS CLI Availability
    [Documentation]    Verify AWS CLI is installed and available
    ${result}=    Run Process    which    aws
    Log    Command: which aws
    Log    Exit Code: ${result.rc}
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Should Be Equal As Integers    ${result.rc}    0
    Log    AWS CLI found at: ${result.stdout}
    
    ${version}=    Run Process    aws    --version
    Log    Command: aws --version
    Log    Exit Code: ${version.rc}
    Log    STDOUT: ${version.stdout}
    Log    STDERR: ${version.stderr}
    Should Be Equal As Integers    ${version.rc}    0
    Log    AWS CLI version: ${version.stdout}

Test AWS Credentials
    [Documentation]    Verify AWS credentials are properly configured
    Log    Testing AWS credentials...
    ${result}=    Run Process    aws    sts    get-caller-identity
    Log    Command: aws sts get-caller-identity
    Log    Exit Code: ${result.rc}
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Should Be Equal As Integers    ${result.rc}    0
    Log    AWS credentials are working!
    Log    Caller identity: ${result.stdout}

Test Basic AWS Operations
    [Documentation]    Test basic AWS S3 operations
    Log    Testing basic AWS operations...
    ${result}=    Run Process    aws    s3    ls
    Log    Command: aws s3 ls
    Log    Exit Code: ${result.rc}
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    # This may fail if no S3 access or no buckets, which is acceptable
    IF    ${result.rc} != 0
        Log    No S3 access or no buckets
    ELSE
        Log    S3 buckets listed successfully
        Log    ${result.stdout}
    END

Test S3 Download
    [Documentation]    Download a file from S3 bucket
    Log    Testing S3 download...
    
    # Download file from S3
    ${result}=    Run Process    aws    s3    cp    
    ...    s3://${BUCKET_NAME}/${FILE_KEY}    ${LOCAL_FILE}
    Log    Command: aws s3 cp s3://${BUCKET_NAME}/${FILE_KEY} ${LOCAL_FILE}
    Log    Exit Code: ${result.rc}
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Should Be Equal As Integers    ${result.rc}    0
    Log    File downloaded successfully
    
    # Verify file exists
    File Should Exist    ${LOCAL_FILE}
    
    # Check file details
    ${size}=    Get File Size    ${LOCAL_FILE}
    Log    File size: ${size} bytes
    
    # Display file contents
    ${contents}=    Get File    ${LOCAL_FILE}
    Log    File contents:\n${contents}
    
*** Keywords ***
Setup Test Environment
    [Documentation]    Ensure AWS environment variables are set
    ${aws_key}=    Get Environment Variable    AWS_ACCESS_KEY_ID    ${EMPTY}
    ${aws_secret}=    Get Environment Variable    AWS_SECRET_ACCESS_KEY    ${EMPTY}
    Run Keyword If    '${aws_key}' == '${EMPTY}'    
    ...    Fail    AWS_ACCESS_KEY_ID environment variable not set
    Run Keyword If    '${aws_secret}' == '${EMPTY}'    
    ...    Fail    AWS_SECRET_ACCESS_KEY environment variable not set
