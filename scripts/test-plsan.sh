#!/bin/bash

# Test File Directory
test_cases_dir="testcases"

# List of Testcases (.c and .cpp)
test_cases=$(find $test_cases_dir -type f \( -name "*.c" -o -name "*.cpp" \))

# Amount of Testcases
total_files=$(find $test_cases_dir -type f \( -name "*.c" -o -name "*.cpp" \) | wc -l)

# init leak detected count and no leak count.
_actual_TP=79
_actual_FP=0
_actual_TN=32
_actual_FN=0

#############################

_TP=0
_FP=0
_TN=0
_FN=0

#############################

_count=0

# define checking leak function
check_actual_output() {
  if [[ $1 == *"noleak"* ]]; then
    echo 1
  else
    echo 0
  fi
}

for test_case in $test_cases; do
  file_extension="${test_case##*.}"

  file_name=$(basename "$test_case")
  
  # replace extension from filename.
  file_base_name="${file_name%.*}"
  
  # add count
  ((_count++))

  # setting up compile options.
  if [ "$file_extension" == "cpp" ]; then
    compile_options="-fpass-plugin=`echo build/PreciseLeakSanitizer/PreciseLeakSanitizer.so` -lstdc++ -Wno-everything -g `echo build/RuntimeLibrary/libplsan.a`"
  else
    compile_options="-fpass-plugin=`echo build/PreciseLeakSanitizer/PreciseLeakSanitizer.so` -Wno-everything -g build/RuntimeLibrary/libplsan.a" # -Wno-everything option is for developing!
  fi

  # compiling testcases
  clang $compile_options $test_case -o $file_base_name

  # is compilation successed?
  if [ $? -eq 0 ]; then

    # execute testcases and save LeakSanitizer's output.
    sanitizer_output=$(./$file_base_name 2>&1)

    # Is it leak?
    if [[ $sanitizer_output == *"LeakSanitizer"* ]];  then
      echo "[$_count] Leak : $test_case"

      if [[ $(check_actual_output "$test_case") == 1 ]]; then # is it no leak?
        ((_FP++))
      else
        ((_TP++))
      fi

    else
      echo "[$_count] No Leak : $test_case"

      if [[ $(check_actual_output "$test_case") == 1 ]]; then # is it no leak?
        ((_TN++))
      else
        ((_FN++))
      fi
    fi
  else
    echo "Compilation Failed : $test_case"
  fi

  rm -f ./$file_base_name
done

# Print results
echo -e "\nTestcases: $total_files\n"

echo "True Positive : $_TP"
echo "False Positive : $_FP"
echo "True Negative : $_TN"
echo "False Negative : $_FN"

if [ $_TP != $_actual_TP ]; then
  if [ $_FP != $_actual_FP ]; then
    if [ $_TN != $_actual_TN ]; then
      if [ $_FN != $_actual_FN ]; then
        exit 1
      fi
      exit 1
    fi
    exit 1
  fi
  exit 1
fi