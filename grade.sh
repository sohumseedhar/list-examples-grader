CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

cp student-submission/*.java grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area 

if ! [ -f ListExamples.java ]
then 
    echo "Missing  ListExamples.java in student submission]"
    echo "Score: 0"
    exit 
fi 

javac -cp $CPATH *.java &> compile.txt 
if [ $? -ne 0 ]
then 
    echo " Compilation Error"
    echo "Score:0"
    exit 
fi

output=$(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples)


echo "$output"

# Extract results from the output
lastline=$(echo "$output" | tail -n 2 | head -n 1)
echo "Last line of output: $lastline" # Debugging output

# Ensure we have correct parsing logic
tests=$(echo $lastline | cut -d ' ' -f 2 | cut -d ',' -f 1)
failures=$(echo $lastline | cut -d ' ' -f 5 | cut -d ',' -f 1)

# Print parsed values for debugging
echo "Tests: $tests, Failures: $failures" # Debugging output

# Handle cases where tests or failures might be empty
if [[ -z "$tests" ]]; then
    tests=0
fi

if [[ -z "$failures" ]]; then
    failures=0
fi



#lastline=$(echo "$output" | tail -n 2 | head -n 1)
#tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
#failures=$(echo $lastline | awk -F'[, ]' '{print $6}')

successes=$((tests - failures))

echo "Your score is $successes / $tests"


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
