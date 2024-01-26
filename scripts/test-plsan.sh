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

_FP_TC_LIST=()
_FN_TC_LIST=()

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

  compile_options="-fpass-plugin=build/PreciseLeakSanitizer/PreciseLeakSanitizer.so"
  compile_options+=" -g -c -Wno-everything"
  link_options=" -L build/RuntimeLibrary -lplsan -ldw"
  # setting up compile options.
  if [ "$file_extension" == "cpp" ]; then
    compiler=clang++
    link_options+=" -lstdc++"
  else
    compiler=clang
    compile_options+=""
  fi

  # compiling and link
  $compiler $test_case $compile_options -o $file_base_name.o && \
    clang++ ./$file_base_name.o $link_options -o $file_base_name

  # is compilation successed?
  if [ $? -eq 0 ]; then

    # execute testcases and save LeakSanitizer's output.
    sanitizer_output=$(./$file_base_name 2>&1)

    # Is it leak?
    if [[ $sanitizer_output == *"LeakSanitizer"* ]];  then
      echo "[$_count] Leak : $test_case"

      if [[ $(check_actual_output "$test_case") == 1 ]]; then # is it no leak?
        ((_FP++))
        _FP_TC_LIST+=("    - $test_case\n")
      else
        ((_TP++))
      fi

    else
      echo "[$_count] No Leak : $test_case"

      if [[ $(check_actual_output "$test_case") == 1 ]]; then # is it no leak?
        ((_TN++))
      else
        ((_FN++))
        _FN_TC_LIST+=("    - $test_case\n")
      fi
    fi
  else
    echo "Compilation Failed : $test_case"
  fi

  rm -f ./$file_base_name ./$file_base_name.o
done

# Print results
echo -e "\nTestcases: $total_files\n"

echo "True Positive : $_TP"
echo "False Positive : $_FP"
for element in "${_FP_TC_LIST[@]}"; do
    echo "$element"
done
echo "True Negative : $_TN"
echo "False Negative : $_FN"
for element in "${_FN_TC_LIST[@]}"; do
    echo "$element"
done

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
